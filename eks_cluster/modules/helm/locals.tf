data "aws_region" "this" {}
data "aws_caller_identity" "this" {}
data "aws_availability_zones" "this" {}

locals {
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.this.account_id
  # change to this for aws3.0 hosted_zone_name = data.aws_route53_zone.selected.name
  hosted_zone_name = trimsuffix(data.aws_route53_zone.selected.name, ".")

  externaldns_vars = {
    hosted_zone_id       = data.aws_route53_zone.selected.zone_id
    hosted_zone_name     = local.hosted_zone_name
    externaldns_role_arn = var.externaldns_role_arn
  }

  externaldns_chart_values = templatefile(
    "${path.module}/values/external-dns.yaml.tpl",
    local.externaldns_vars
  )

  nginx_ingress_vars = {
    acm_certificate_arn = data.aws_acm_certificate.wildcard.arn
  }

  nginx_ingress_chart_values = templatefile(
    "${path.module}/values/nginx-ingress.yaml.tpl",
    local.nginx_ingress_vars
  )

  cert_manager_vars = {
    cert_manager_role_arn = var.cert_manager_role_arn
  }

  cert_manager_chart_values = templatefile(
    "${path.module}/values/cert-manager.yaml.tpl",
    local.cert_manager_vars
  )

  cluster_autoscaler_vars = {
    cluster_name = var.cluster_name
    region       = var.region
    repository   = var.cluster_autoscaler_repository
    tag          = var.cluster_autoscaler_tag
  }

  cluster_autoscaler_chart_values = templatefile(
    "${path.module}/values/cluster-autoscaler.yaml.tpl",
    local.cluster_autoscaler_vars
  )

  prometheus_vars = {
    cluster_name = var.cluster_name
  }

  prometheus_chart_values = templatefile(
    "${path.module}/values/prometheus.yaml.tpl",
    local.prometheus_vars
  )

  grafana_vars = {
    hosted_zone_name = local.hosted_zone_name
  }

  grafana_chart_values = templatefile(
    "${path.module}/values/grafana.yaml.tpl",
    local.grafana_vars
  )

  velero_vars = {
    # basic setup
    cluster_name = var.cluster_name
    bucket_name  = var.velero_bucket
    region       = local.region

    # role setup
    velero_role_arn = var.velero_role_arn
  }

  velero_chart_values = templatefile(
    "${path.module}/values/velero.yaml.tpl",
    local.velero_vars
  )

  external_secret_vars = {
    region                    = var.region
    external_secrets_role_arn = var.external_secrets_role_arn
  }

  external_secret_chart_values = templatefile(
    "${path.module}/values/external-secrets.yaml.tpl",
    local.external_secret_vars
  )

  cluster_issuer_yaml_vars = {
    email_address         = "certificates@forteplatform.io"
    region                = var.region
    cert_manager_role_arn = var.cert_manager_role_arn
  }

  cluster_issuer_yaml = templatefile(
    "${path.module}/values/cluster-issuer.yaml.tpl",
    local.cluster_issuer_yaml_vars
  )
}
