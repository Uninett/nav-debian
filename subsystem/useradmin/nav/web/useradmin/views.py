# -*- coding: utf-8 -*-
#
# Copyright 2008 UNINETT AS
#
# This file is part of Network Administration Visualized (NAV)
#
# NAV is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# NAV is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NAV; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Authors: Thomas Adamcik <thomas.adamcik@uninett.no>
#

__copyright__ = "Copyright 2008 UNINETT AS"
__license__ = "GPL"
__author__ = "Thomas Adamcik (thomas.adamcik@uninett.no)"
__id__ = "$Id$"

from django.core.urlresolvers import reverse
from django.http import HttpResponseRedirect, Http404
from django.shortcuts import get_object_or_404, get_list_or_404
from django.template import RequestContext

from nav.models.profiles import Account, AccountGroup
from nav.django.shortcuts import render_to_response, object_list, object_detail

from nav.web.templates.UserAdmin import UserAdmin
from nav.web.useradmin.forms import *

def account_list(request):
    return object_list(UserAdmin, request, Account.objects.all(),
                        template_object_name='account',
                        template_name='useradmin/account_list.html',
                        extra_context={'active': {'account_list': 1}})

def account_detail(request, account_id=None):
    try:
        account = Account.objects.get(id=account_id)
    except Account.DoesNotExist:
        account = None

    account_form = AccountForm(instance=account)
    org_form = OrganizationForm()
    group_form = GroupForm()

    return render_to_response(UserAdmin, 'useradmin/account_detail.html',
                        {
                            'active': {'account_detail': True},
                            'account': account,
                            'account_form': account_form,
                            'org_form': org_form,
                            'group_form': group_form,
                        }, RequestContext(request))

def group_list(request):
    return object_list(UserAdmin, request, AccountGroup.objects.all(),
                        template_object_name='group',
                        template_name='useradmin/group_list.html',
                        extra_context={'active': {'group_list': 1}})

def group_detail(request, group_id=None):
    pass
