
resource "null_resource" "kube_config" {
  depends_on = [yandex_kubernetes_cluster.netology-k8s]

  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.netology-k8s.id} --external --kubeconfig kube.config --force"
  }
  triggers = {
    always_run         = "${timestamp()}"                         # всегда т.к. дата и время постоянно изменяются
  }
}

resource "local_file" "phpmyadmin_yaml" {
  depends_on = [yandex_kubernetes_cluster.netology-k8s]
  content = templatefile("${path.module}/phpmyadmin.tmplt",
    {
      mysql-service = yandex_mdb_mysql_cluster.cluster01.host[0].fqdn
    }
  )

  filename = "${abspath(path.module)}/phpmyadmin.yaml"
}

resource "null_resource" "kube_objects" {
  depends_on = [
    local_file.phpmyadmin_yaml,
    null_resource.kube_config
  ]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig kube.config apply -f phpmyadmin.yaml"
  }

  triggers = {
    always_run         = "${timestamp()}"                         # всегда т.к. дата и время постоянно изменяются
  }
}