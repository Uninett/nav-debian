#!/bin/sh -e

NONINTERACTIVE=1 ./dev.sh gbp buildpackage --git-ignore-new --git-builder="debuild --no-lintian -i -I -us -uc"

output=$(dirname $(dirname "$PWD"))
cat <<EOF

You should find your packages ready for signing with debsign in the
following directory:
${output}
EOF
