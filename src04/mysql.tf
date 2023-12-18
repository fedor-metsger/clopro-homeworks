
resource "yandex_mdb_mysql_cluster" "cluster01" {
  name                = "cluster01"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.net.id
  version             = "8.0"
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = "ru-central1-a"
    name      = "na-1"
    subnet_id = module.private_subnets.subnet_ids[0].id
  }
  host {
    zone      = "ru-central1-b"
    name      = "na-2"
    subnet_id = module.private_subnets.subnet_ids[1].id
  }
  host {
    zone                    = "ru-central1-c"
    name                    = "nb-1"
    replication_source_name = "na-1"
    subnet_id               = module.private_subnets.subnet_ids[2].id
  }

  backup_window_start {
    hours = "23"
    minutes = "59"
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster01.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology_user" {
    cluster_id = yandex_mdb_mysql_cluster.cluster01.id
    name       = "netology_user"
    password   = "Qwer1234"

    permission {
      database_name = yandex_mdb_mysql_database.netology_db.name
      roles         = ["ALL"]
    }
}