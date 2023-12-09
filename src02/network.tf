
resource "yandex_vpc_network" "net" {
  name = "lab"
}

module "public_subnets" {
  source  = "../src/vpc"
  vpc_id  = yandex_vpc_network.net.id
  data = [
    {
      name = "public",
      zone = "ru-central1-a",
      cidr = "192.168.10.0/24"
    }
  ]
}