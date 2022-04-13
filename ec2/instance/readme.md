# Module - EC2

- [Module - EC2](#module---ec2)
  - [Minimum Required Configuration](#minimum-required-configuration)
  - [Inputs and Outputs](#inputs-and-outputs)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

This modules serves as a baseline for EC2 deployments.  Many variables can be overridden to provide consistency across an environment.

This module only provides the EC2 instance.  It does **not** create IAM roles or security groups.

## Minimum Required Configuration

EBS encryption is not required but included in this example.  Encryption is strongly recommended.

```terraform
module "ec2_example" {
  source = "../relative/path/to/modules/ec2"

  ami                  = "ami-XXXXXXXX"
  key_name             = "XXXXXXXX"

  root_block_device = [{
    encrypted   = true
    kms_key_id  = XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    volume_type = "gp2"
    volume_size = 8
  }]

  subnet_id              = "subnet-XXXXXXXX"
  vpc_security_group_ids = [ "sg-XXXXXXXX" ]
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
| ami | Base Amazon Machine Image (AMI) | `string` | n/a | yes |
| associate\_public\_ip\_address | Associate a public IP address | `bool` | `false` | no |
| disable\_api\_termination | Prevent instances from being accidentally terminated | `bool` | `true` | no |
| ebs\_block\_device | List of maps containing additional EBS volumes | `list(map(string))` | `[]` | no |
| enable\_detailed\_monitoring | Detailed monitoring delivers 1 minute instance metrics for an extra cost.  Basic monitoring is 5 minutes. | `bool` | `false` | no |
| iam\_instance\_profile | IAM instance profile \*Name\* associated with the IAM role to attach to the instance | `string` | `""` | no |
| instance\_type | Instance type | `string` | `"t3a.small"` | no |
| key\_name | Key Pair for instance access (key name, NOT key ID) | `string` | n/a | yes |
| private\_ip | Optionally specify a specific private IP address | `string` | `""` | no |
| root\_block\_device | Root EBS volume definition | `list(map(string))` | n/a | yes |
| source\_dest\_check | Source and destination packet checks.  Disable only for NAT or VPN related instances. | `bool` | `true` | no |
| subnet\_id | Target subnet for instance deployment | `string` | n/a | yes |
| tags | Tags to apply to all module resources. | `map` | `{}` | no |
| user\_data | User data to launch the instance with.  Will be base64 encoded by this module. | `string` | `""` | no |
| volume\_tags | Map of tags to add to attached EBS volumes | `map` | `{}` | no |
| vpc\_security\_group\_ids | List of security group IDs to associate with the instance | `list(string)` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| id | Instance ID |
| private\_ip | Private IP Address |
| public\_ip | Public IP Address |
| security\_groups | Attached security groups |
| subnet\_id | Subnet ID |
