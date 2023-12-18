
resource "yandex_vpc_network" "net" {
  name = "lab"
}

module "public_subnets" {
  source  = "./vpc"
  vpc_id  = yandex_vpc_network.net.id
  data = [
    {
      name = "public1",
      zone = "ru-central1-a",
      cidr = "192.168.10.0/24"
    },
    {
      name = "public2",
      zone = "ru-central1-b",
      cidr = "192.168.50.0/24"
    },
    {
      name = "public3",
      zone = "ru-central1-c",
      cidr = "192.168.60.0/24"
    }
  ]
}

module "private_subnets" {
  source  = "./vpc"
  vpc_id  = yandex_vpc_network.net.id
  data = [
    {
      name = "private1",
      zone = "ru-central1-a",
      cidr = "192.168.20.0/24"
    },
    {
      name = "private2",
      zone = "ru-central1-b",
      cidr = "192.168.30.0/24"
    },
    {
      name = "private3",
      zone = "ru-central1-c",
      cidr = "192.168.40.0/24"
    }
  ]
#  route_table = yandex_vpc_route_table.nat-rt.id
}
