
resource "yandex_kubernetes_cluster" "netology-k8s" {
  name        = "netology-k8s"

  network_id = yandex_vpc_network.net.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = module.public_subnets.subnet_ids[0].id
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = module.public_subnets.subnet_ids[1].id
      }

      location {
        zone      = "ru-central1-c"
        subnet_id = module.public_subnets.subnet_ids[2].id
      }
    }
    version   = "1.27"
    public_ip = true
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }

  service_account_id      = "${yandex_iam_service_account.k8s-sa.id}"
  node_service_account_id = "${yandex_iam_service_account.k8s-sa.id}"

  release_channel = "STABLE"

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-sa-admin
  ]
}

resource "yandex_kubernetes_node_group" "k8s-workers" {
  cluster_id  = "${yandex_kubernetes_cluster.netology-k8s.id}"
  name        = "k8s-workers"
  version     = "1.27"

  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [
        module.public_subnets.subnet_ids[0].id
      ]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }
}