#
# Copyright (C) 2013 Uninett AS
#
# This file is part of Network Administration Visualized (NAV).
#
# NAV is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.  You should have received a copy of the GNU General Public License
# along with NAV. If not, see <http://www.gnu.org/licenses/>.
#
"""A NAV wsgi application"""
from __future__ import absolute_import

from nav.bootstrap import bootstrap_django
from nav.web import loginit

bootstrap_django(__file__)


loginit()
from django.core.wsgi import get_wsgi_application

# Such is the WSGI api:
# pylint: disable=C0103
application = get_wsgi_application()
