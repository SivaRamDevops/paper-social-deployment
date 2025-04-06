provider "helm" {
  kubernetes {
    host  = ibm_container_vpc_cluster.cluster.master_url
    token = data.ibm_container_vpc_cluster_config.cluster_config.token
    cluster_ca_certificate = base64decode(
      ibm_container_vpc_cluster.cluster.master_cert
    )
  }
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  depends_on = [ibm_container_vpc_cluster.cluster]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  depends_on = [ibm_container_vpc_cluster.cluster]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.service.type"
    value = "ClusterIP"
  }

  depends_on = [ibm_container_vpc_cluster.cluster]
} 