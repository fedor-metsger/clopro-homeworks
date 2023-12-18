
output subnet_ids {
  value = [
    for sn in yandex_vpc_subnet.subnets.* : {
      name = sn["name"],
      id = sn["id"]
    }
  ]
}
