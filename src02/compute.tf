
data template_file "userdata" {
  template = file("${path.module}/cloud-init.yaml")

  vars = {
    ssh_public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "yandex_compute_instance_group" "front" {
  name                = "front"
  folder_id           = "${var.folder_id}"
  service_account_id  = "${yandex_iam_service_account.sa.id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v2"
    scheduling_policy {
      preemptible = true
    }
    resources {
      memory        = 2
      cores         = 2
      core_fraction = 5
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 8
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.net.id}"
      subnet_ids = [module.public_subnets.subnet_ids[0].id]
      nat        = true
    }
    metadata = {
      user-data          = data.template_file.userdata.rendered
      serial-port-enable = 1
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.front.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}
