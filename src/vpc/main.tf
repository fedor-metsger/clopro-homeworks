
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_subnet" "subnets" {
  count          = length(var.data)

  name           = "${var.data[count.index].name}"
  zone           = "${var.data[count.index].zone}"
  network_id     = var.vpc_id
  v4_cidr_blocks = ["${var.data[count.index].cidr}"]
  route_table_id = "${var.route_table}"
}
