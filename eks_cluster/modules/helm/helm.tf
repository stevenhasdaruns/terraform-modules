# DATA
data "aws_route53_zone" "selected" {
  zone_id = var.externaldns_lookup_zone
}

data "aws_acm_certificate" "wildcard" {
  domain   = "*.${local.hosted_zone_name}"
  statuses = ["ISSUED"]
}

# HELM
# RM tiller  + bump module version for helm 3
provider "helm" {
  #version = "~> 2.0.0"
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = var.cluster_ca_certificate
    token                  = var.token
    #load_config_file       = false
  }
}

provider "kubectl" {
  host                   = var.host
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = var.token
  load_config_file       = false
}

resource "helm_release" "externaldns" {
  count         = var.enable_externaldns ? 1 : 0
  name          = "externaldns"
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "external-dns"
  namespace     = "networking"
  force_update  = true
  recreate_pods = true

  values = [local.externaldns_chart_values]
}

resource "helm_release" "nginx_ingress" {
  depends_on    = [kubernetes_namespace.networking]
  count         = var.enable_nginx_ingress ? 1 : 0
  name          = "nginx"
  repository    = "https://charts.helm.sh/stable"
  chart         = "nginx-ingress"
  namespace     = "networking"
  force_update  = true
  recreate_pods = true

  values = [local.nginx_ingress_chart_values]
}

resource "helm_release" "cluster_autoscaler" {
  count         = var.enable_cluster_autoscaler ? 1 : 0
  name          = "autoscaler"
  repository    = "https://kubernetes.github.io/autoscaler"
  chart         = "cluster-autoscaler"
  namespace     = "kube-system"
  force_update  = true
  recreate_pods = true

  values = [local.cluster_autoscaler_chart_values]
}

resource "helm_release" "prometheus" {
  depends_on    = [helm_release.efs_provisioner]
  count         = var.enable_prometheus ? 1 : 0
  name          = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "prometheus"
  namespace     = "prometheus"
  force_update  = true
  recreate_pods = true
  version       = "13.7.0"

  values = [local.prometheus_chart_values]
}

resource "helm_release" "grafana" {
  depends_on    = [helm_release.prometheus]
  count         = var.enable_grafana ? 1 : 0
  name          = "grafana"
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "grafana"
  namespace     = "prometheus"
  force_update  = true
  recreate_pods = true

  values = [local.grafana_chart_values]
}

# resource "helm_release" "velero" {
#   count      = var.enable_velero ? 1 : 0
#   name       = "velero"
#   repository = "${path.module}/velero-chart/charts"
#   chart      = "velero"
#   #version    = "2.22.0"
#   namespace  = "velero"
#   create_namespace = true
#   # force_update  = true
#   # recreate_pods = true

#   values = [local.velero_chart_values]
# }

resource "helm_release" "velero" {
  count      = var.enable_velero ? 1 : 0
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "2.26.2"
  namespace  = "velero"
  create_namespace = true
  # force_update  = true
  # recreate_pods = true

  values = [local.velero_chart_values]
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0
  metadata {
    annotations = {
      name = "cert-manager"
    }

    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }

    name = "cert-manager"
  }
}
resource "kubernetes_namespace" "networking" {
  count = var.enable_nginx_ingress ? 1 : 0
  metadata {
    annotations = {
      name = "networking"
    }

    name = "networking"
  }
}

resource "helm_release" "cert_manager" {
  count         = var.enable_cert_manager ? 1 : 0
  name          = "cert-manager"
  repository    = "https://charts.jetstack.io"
  chart         = "cert-manager"
  namespace     = "cert-manager"
  version       = "v1.3.0"
  force_update  = true
  recreate_pods = true
  values        = [local.cert_manager_chart_values]
  provisioner "local-exec" {
    command = "sleep 50"
  }
}

resource "helm_release" "efs_provisioner" {
  count         = var.enable_efs_provisioner ? 1 : 0
  name          = "efs"
  repository    = "https://charts.helm.sh/stable"
  chart         = "efs-provisioner"
  namespace     = "networking"
  force_update  = true
  recreate_pods = true

  set {
    name  = "efsProvisioner.awsRegion"
    value = var.region
  }

  set {
    name  = "efsProvisioner.efsFileSystemId"
    value = var.efs_fs_id
  }
}

resource "helm_release" "external_secrets" {
  count            = var.enable_external_secrets ? 1 : 0
  name             = "external-secrets"
  repository       = "https://external-secrets.github.io/kubernetes-external-secrets/"
  chart            = "kubernetes-external-secrets"
  namespace        = "external-secrets"
  force_update     = true
  recreate_pods    = true
  create_namespace = true
  values           = [local.external_secret_chart_values]
}

module "container_insights" {
  source               = "matti/resource/shell"
  version              = "1.2.0"
  command              = "curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/quickstart/cwagent-fluentd-quickstart.yaml | sed \"s/{{cluster_name}}/${var.cluster_name}/;s/{{region_name}}/${local.region}/\""
  command_when_destroy = "curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed \"s/{{cluster_name}}/${var.cluster_name}/;s/{{region_name}}/${local.region}/\" | kubectl delete -f -"
}

resource "kubectl_manifest" "container_insights" {
  count      = var.enable_container_insights ? 1 : 0
  depends_on = [module.container_insights]
  yaml_body  = module.container_insights.stdout
}

resource "kubectl_manifest" "acme_clusterissuer" {
  depends_on = [helm_release.cert_manager]
  count      = var.enable_cert_manager ? 1 : 0
  yaml_body  = local.cluster_issuer_yaml
}

resource "kubectl_manifest" "fluentd" {
  count     = var.enable_fluentd ? 1 : 0
  yaml_body = file("${path.module}/values/fluentd.yaml")
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# resource "kubectl_manifest" "demo_schedule" {
#   count     = var.enable_demo_scheduler ? 1 : 0
#   yaml_body = file("${path.module}/values/demo-scheduler.yaml")
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }
