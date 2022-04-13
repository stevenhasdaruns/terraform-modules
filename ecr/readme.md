# Module - Elastic Container Registry (ECR)

- [Module - Application Load Balancer (ALB)](#module---application-load-balancer-alb)
  - [Minimum Required Configuration](#minimum-required-configuration)
  - [Inputs and Outputs](#inputs-and-outputs)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

This module deploys an ECR repository with an lifecycle policy to expire untagged images.

## Minimum Required Configuration

Substitute the details below for your cluster.

```terraform
module "example" {
  source     = "../relative/path/to/modules/ecr"
  name       = "example"
}
```

## Inputs and Outputs

Inputs and outputs are generated with [terraform-docs](https://github.com/segmentio/terraform-docs)

```bash
terraform-docs markdown table . | sed s/##/###/g
```

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| name | Repository name | `string` | n/a | yes |
| tags | Tags to apply to all module resources. | `map` | `{}` | no |
| untagged\_retention | Number of days to retain untagged images | `number` | `30` | no |

### Outputs

| Name | Description |
|------|-------------|
| arn | Repository ARN |
| name | Repository name |
| url | Repository URL form |
