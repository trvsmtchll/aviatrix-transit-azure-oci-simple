data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_ocid
  ad_number      = 1
}

resource "oci_core_instance" "flex_vm" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.display_name
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = var.subnet_id #data.oci_core_subnets.spoke_subnets.subnets[0].id
    display_name     = "${var.display_name}-nic"
    assign_public_ip = true
    nsg_ids          = var.nsg_ids
  }

  source_details {
    source_type = "image"
    source_id   = var.flex_instance_image_ocid[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/userdata/bootstrap.sh")) #file("${path.module}/../../userdata/linux_mount.sh")
  }

}
