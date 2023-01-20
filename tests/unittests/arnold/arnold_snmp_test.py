"""Tests for Arnold using snmp objects"""
from nav.arnold import change_port_status
from mock import Mock, patch
import unittest


@patch('nav.Snmp.Snmp', autospec=True)
class TestArnoldSnmp(unittest.TestCase):
    """Testclass for Arnold"""

    def setUp(self):
        self.ip = '10.0.0.1'
        self.read_write = 'public'
        self.read_only = 'private'
        self.ifindex = 1
        self.port_status_oid = '.1.3.6.1.2.1.2.2.1.7'

        self.profile = self.create_management_profile_mock()
        self.netbox = self.create_netbox_mock()
        self.interface = self.create_interface_mock()

    def create_interface_mock(self):
        """Create interface model mock object"""
        interface = Mock()
        interface.netbox = self.netbox
        interface.ifindex = self.ifindex
        return interface

    def create_management_profile_mock(self):
        """Create management profile model mock object"""
        profile = Mock()
        profile.snmp_version = 1
        profile.snmp_community = "public"
        return profile

    def create_netbox_mock(self):
        """Create netbox model mock object"""
        netbox = Mock()
        netbox.ip = self.ip
        netbox.type.vendor.id = 'cisco'
        netbox.get_preferred_snmp_management_profile.return_value = self.profile
        return netbox

    def test_change_port_status_enable(self, snmp):
        """Test enabling of a port"""
        instance = snmp.return_value
        identity = Mock()
        identity.interface = self.interface
        change_port_status('enable', identity)

        snmp.assert_called_once_with(
            self.ip, self.profile.snmp_community, self.profile.snmp_version
        )
        instance.set.assert_called_once_with(
            self.port_status_oid + '.' + str(self.ifindex), 'i', 1
        )

    def test_change_port_status_disable(self, snmp):
        """Test disabling of a port"""
        instance = snmp.return_value
        identity = Mock()
        identity.interface = self.interface
        change_port_status('disable', identity)

        snmp.assert_called_once_with(
            self.ip, self.profile.snmp_community, self.profile.snmp_version
        )
        instance.set.assert_called_once_with(
            self.port_status_oid + '.' + str(self.ifindex), 'i', 2
        )
