variable "instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_memory_in_gbs" {
  default = 1
}

variable "ssh_public_key" {
}

variable "nsg_ids" {
}

variable "vcn_id" {
}

variable "subnet_id" {
}

variable "display_name"{
  }

variable "compartment_ocid" {
}

variable "region" {
  default = ""
}

variable "flex_instance_image_ocid" {
  type = map(string)
  default = {
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa6hooptnlbfwr5lwemqjbu3uqidntrlhnt45yihfj222zahe7p3wq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa6tp7lhyrcokdtf7vrbmxyp2pctgg4uxvt4jz4vc47qoc2ec4anha"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadvi77prh3vjijhwe5xbd6kjg3n5ndxjcpod6om6qaiqeu3csof7a"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaw5gvriwzjhzt2tnylrfnpanz5ndztyrv3zpwhlzxdbkqsjfkwxaq"
  }
}