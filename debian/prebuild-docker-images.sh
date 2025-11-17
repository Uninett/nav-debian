#!/usr/bin/env bash
set -e

# Script to prebuild Docker images for all maintained Debian branches
# Can be run in parallel using tmux or individually for specific branches

# Configuration
BRANCHES=("debian-bullseye" "debian-bookworm" "debian-trixie")
TMUX_SESSION="nav-docker-build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Prebuild Docker images for NAV Debian packages.

Options:
  -b, --branch BRANCH     Build specific branch (bullseye, bookworm, or trixie)
  -w, --workdir DIR       Working directory for clones (default: /tmp/nav-docker-prebuild-\$\$)
  -k, --keep              Keep work directory even after successful builds
  -h, --help              Show this help message
Without options, builds all branches in parallel using tmux.
Work directory is automatically cleaned up after successful builds unless -k is used.

Examples:
  $0                      # Build all branches in parallel with tmux
  $0 -b bookworm          # Build only the bookworm branch
  $0 -b trixie -w /tmp/mybuild  # Build trixie with specific work directory
  $0 -k                   # Build all branches and keep work directory

EOF
    exit 0
}

# Parse command line arguments
BRANCH=""
WORK_DIR=""
KEEP_WORKDIR=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -w|--workdir)
            WORK_DIR="$2"
            shift 2
            ;;
        -k|--keep)
            KEEP_WORKDIR=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Set default work directory if not specified
if [ -z "$WORK_DIR" ]; then
    WORK_DIR="/tmp/nav-docker-prebuild-$$"
fi

# Function to build a single branch
build_single_branch() {
    local branch_short=$1
    local work_dir=$2

    # Map short name to full branch name
    local branch_full=""
    case $branch_short in
        bullseye)
            branch_full="debian-bullseye"
            ;;
        bookworm)
            branch_full="debian-bookworm"
            ;;
        trixie)
            branch_full="debian-trixie"
            ;;
        debian-*)
            # Allow full branch names too
            branch_full="$branch_short"
            branch_short="${branch_short#debian-}"
            ;;
        *)
            echo -e "${RED}Error: Unknown branch '$branch_short'${NC}"
            echo "Valid branches: bullseye, bookworm, trixie"
            exit 1
            ;;
    esac

    # Determine base directory
    local base_dir=""
    if [ "$(basename $(pwd))" = "debian" ]; then
        base_dir=$(dirname $(pwd))
    else
        # Try to find the debian directory
        if [ -d "debian" ]; then
            base_dir=$(pwd)
        else
            echo -e "${RED}Error: Cannot find debian directory${NC}"
            echo "Run this script from the repository root or debian/ directory"
            exit 1
        fi
    fi

    local clone_dir="$work_dir/$branch_full"
    local log_file="$work_dir/${branch_full}.log"

    echo -e "${BLUE}=================================================================================${NC}"
    echo -e "${BLUE}Building Docker image for branch: ${GREEN}$branch_full${NC}"
    echo -e "${BLUE}=================================================================================${NC}"
    echo "Clone directory: $clone_dir"
    echo "Log file: $log_file"
    echo ""

    # Create work directory (but not clone directory - git will create it)
    mkdir -p "$work_dir"

    # Clone the branch
    echo -e "${YELLOW}Cloning branch $branch_full...${NC}"
    if ! git clone --depth 1 --branch "$branch_full" "$base_dir" "$clone_dir" 2>&1 | tee -a "$log_file"; then
        echo -e "${RED}Failed to clone branch $branch_full${NC}"
        mkdir -p "$clone_dir"  # Create it just for the status file
        touch "$clone_dir/.build-failed"
        exit 1
    fi

    # Mark build as started
    touch "$clone_dir/.build-started"

    # Change to debian directory
    cd "$clone_dir/debian" || exit 1

    # Determine Docker tag
    local docker_tag="debdev:$branch_short"
    echo ""
    echo -e "${YELLOW}Docker tag: ${GREEN}$docker_tag${NC}"

    # Build Docker image
    echo ""
    echo -e "${YELLOW}Building Docker image...${NC}"
    echo "This may take several minutes..."
    echo ""

    if docker build -t "$docker_tag" . 2>&1 | tee -a "$log_file"; then
        echo ""
        echo -e "${GREEN}✓ Docker image build SUCCESSFUL for $branch_full${NC}"
        echo -e "${GREEN}Image tag: $docker_tag${NC}"
        touch "$clone_dir/.build-complete"
        rm -f "$clone_dir/.build-started"
        echo ""
        echo -e "${GREEN}Build completed. Window kept open for inspection.${NC}"
        echo "You can run additional commands or close this window."
        # Keep the window open by starting user's preferred shell
        exec ${SHELL:-/bin/sh}
    else
        echo ""
        echo -e "${RED}✗ Docker image build FAILED for $branch_full${NC}"
        echo "Check the log file: $log_file"
        touch "$clone_dir/.build-failed"
        rm -f "$clone_dir/.build-started"
        echo ""
        echo -e "${RED}Build failed. Window kept open for debugging.${NC}"
        echo "You can run additional commands or close this window."
        # Keep the window open by starting user's preferred shell
        exec ${SHELL:-/bin/sh}
    fi
}

# Function to setup tmux for parallel builds
setup_tmux_parallel() {
    local work_dir=$1

    # Check if tmux is installed
    if ! command -v tmux &> /dev/null; then
        echo -e "${RED}Error: tmux is not installed. Please install it first.${NC}"
        echo "Install with: sudo apt-get install tmux"
        exit 1
    fi

    # Create work directory
    mkdir -p "$work_dir"

    # Kill existing session if it exists
    tmux kill-session -t "$TMUX_SESSION" 2>/dev/null || true

    # Create new tmux session with overview window
    tmux new-session -d -s "$TMUX_SESSION" -n "overview"

    # Setup overview window with monitoring script
    cat > "$work_dir/monitor.sh" <<'MONITOR_SCRIPT'
#!/usr/bin/env bash
WORK_DIR="$1"
KEEP_WORKDIR="$2"
BRANCHES=("debian-bullseye" "debian-bookworm" "debian-trixie")

clear
echo "NAV Docker Image Prebuild - Overview"
echo "===================================="
echo ""
echo "Branches being built:"
for branch in "${BRANCHES[@]}"; do
    echo "  - $branch"
done
echo ""
echo "Work directory: $WORK_DIR"
echo ""
echo "Commands:"
echo "  - Switch windows: Ctrl-b n (next) or Ctrl-b p (previous)"
echo "  - Window list: Ctrl-b w"
echo "  - Detach: Ctrl-b d"
echo ""

# Give builds a moment to start
sleep 2

while true; do
    # Move cursor to status line
    tput cup 12 0
    echo "Status ($(date +%H:%M:%S)):"
    echo ""

    completed=0
    failed=0

    for branch in "${BRANCHES[@]}"; do
        clone_dir="$WORK_DIR/$branch"
        printf "  %-20s: " "$branch"

        if [ -f "$clone_dir/.build-complete" ]; then
            printf "\033[0;32m✓ COMPLETE\033[0m\n"
            ((completed++))
        elif [ -f "$clone_dir/.build-failed" ]; then
            printf "\033[0;31m✗ FAILED\033[0m\n"
            ((failed++))
        elif [ -f "$clone_dir/.build-started" ]; then
            printf "\033[1;33m⚡ BUILDING...\033[0m\n"
        else
            echo "Waiting..."
        fi
    done

    echo ""
    if [ $((completed + failed)) -eq ${#BRANCHES[@]} ]; then
        printf "\033[0;32m========================================\n"
        echo "All builds finished!"
        echo "Successful: $completed, Failed: $failed"
        printf "========================================\033[0m\n"
        echo ""

        # Clean up work directory if appropriate
        if [ $failed -eq 0 ]; then
            if [ "$KEEP_WORKDIR" = "true" ]; then
                echo "All builds successful. Keeping work directory as requested:"
                echo "  $WORK_DIR"
            else
                echo "All builds successful. Cleaning up work directory..."
                rm -rf "$WORK_DIR"
                echo "Cleanup complete."
            fi
        else
            echo "Some builds failed. Keeping work directory for debugging:"
            echo "  $WORK_DIR"
        fi
        break
    fi

    sleep 2
done
MONITOR_SCRIPT

    chmod +x "$work_dir/monitor.sh"
    tmux send-keys -t "$TMUX_SESSION:overview" "'$work_dir/monitor.sh' '$work_dir' '$KEEP_WORKDIR'" C-m

    # Get script path
    local script_path="$0"
    if [[ ! "$script_path" =~ ^/ ]]; then
        script_path="$(pwd)/$script_path"
    fi

    # Create windows for each branch build
    for branch in "${BRANCHES[@]}"; do
        local branch_short="${branch#debian-}"
        tmux new-window -t "$TMUX_SESSION" -n "$branch_short"
        # Run the build - the script will keep the window open with exec bash
        tmux send-keys -t "$TMUX_SESSION:$branch_short" "'$script_path' -b '$branch_short' -w '$work_dir'" C-m
    done

    # Switch back to overview window
    tmux select-window -t "$TMUX_SESSION:overview"

    # Attach to session
    echo ""
    echo -e "${GREEN}All builds started in tmux session: ${TMUX_SESSION}${NC}"
    echo -e "${GREEN}Attaching to session...${NC}"
    echo ""

    tmux attach -t "$TMUX_SESSION"
}

# Main execution
if [ -n "$BRANCH" ]; then
    # Build single branch
    build_single_branch "$BRANCH" "$WORK_DIR"
else
    # Build all branches in parallel with tmux
    echo -e "${GREEN}Starting parallel Docker image builds for all branches${NC}"
    echo -e "${GREEN}Work directory: ${WORK_DIR}${NC}"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        exit 1
    fi

    setup_tmux_parallel "$WORK_DIR"
fi
