
resource "yandex_vpc_network" "net" {
  name = "lab"
}

module "public_subnets" {
  source  = "./vpc"
  vpc_id  = yandex_vpc_network.net.id
  data = [
    {
      name = "public",
      zone = "ru-central1-a",
      cidr = "192.168.10.0/24"
    }
  ]
}

module "private_subnets" {
  source  = "./vpc"
  vpc_id  = yandex_vpc_network.net.id
  data = [
    {
      name = "private",
      zone = "ru-central1-a",
      cidr = "192.168.20.0/24"
    }
  ]
  route_table = yandex_vpc_route_table.nat-rt.id
}

module "public-vm" {
  source          = "git::https://github.com/fedor-metsger/yandex_compute_instance.git?ref=main"
#  source          = "../../yandex_compute_instance"
  env_name        = "education"
  network_id      = yandex_vpc_network.net.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [module.public_subnets.subnet_ids[0].id]
  instance_name   = "public-vm"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
    user-data          = data.template_file.userdata.rendered
    serial-port-enable = 1
  }
}

module "nat-vm" {
  source             = "git::https://github.com/fedor-metsger/yandex_compute_instance.git?ref=main"
#  source             = "../../yandex_compute_instance"
  env_name           = "education"
  network_id         = yandex_vpc_network.net.id
  subnet_zones       = ["ru-central1-a"]
  subnet_ids         = [module.public_subnets.subnet_ids[0].id]
  security_group_ids = [yandex_vpc_security_group.nat-sg.id]
  instance_name      = "nat-vm"
  instance_count     = 1
#  image_id           = "fd80mrhj8fl2oe87o4e1"
  image_family       = "nat-instance-ubuntu"
  public_ip          = true

  metadata = {
    user-data          = data.template_file.userdata.rendered
    serial-port-enable = 1
  }
}

module "private-vm" {
  source             = "git::https://github.com/fedor-metsger/yandex_compute_instance.git?ref=main"
#  source             = "../../yandex_compute_instance"
  env_name           = "education"
  network_id         = yandex_vpc_network.net.id
  subnet_zones       = ["ru-central1-a"]
  subnet_ids         = [module.private_subnets.subnet_ids[0].id]
  security_group_ids = [yandex_vpc_security_group.nat-sg.id]
  instance_name      = "private-vm"
  instance_count     = 1
  image_family       = "ubuntu-2004-lts"
  public_ip          = false

  metadata = {
    user-data          = data.template_file.userdata.rendered
    serial-port-enable = 1
  }
}

resource "yandex_vpc_security_group" "nat-sg" {
  name       = "nat-sg"
  network_id = yandex_vpc_network.net.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_route_table" "nat-rt" {
  name       = "nat-rt"
  network_id = yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = module.nat-vm.internal_ip_address[0]
  }
}

data template_file "userdata" {
  template = file("${path.module}/cloud-init.yaml")

  vars = {
    ssh_public_key = file("~/.ssh/id_rsa.pub")
  }
}
