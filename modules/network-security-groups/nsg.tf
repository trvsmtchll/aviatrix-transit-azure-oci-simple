resource "oci_core_network_security_group" "nsg" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  #Optional
  display_name = var.nsg_display_name
}

resource "oci_core_network_security_group_security_rule" "rule_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  description = "Egress All"
  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_ssh22" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  description               = "SSH Ingress"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_iperf5201" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  description               = "Iperf3 Ingress"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 5201
      max = 5201
    }
  }
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_all_icmp_type3_code4" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = 1
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = true

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_vcn_icmp_type3" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = 1
  direction                 = "INGRESS"
  source                    = var.vcn_cidr_block
  stateless                 = true

  icmp_options {
    type = 3
  }
}

