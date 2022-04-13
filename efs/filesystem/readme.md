# Module - EFS

- [Module - EFS](#module---efs)
  - [Minimum Required Configuration](#minimum-required-configuration)
  - [Inputs and Outputs](#inputs-and-outputs)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

This module creates an EFS file system and mount targets in the specificed subnets.  1 mount target is deployed per subnet.  It is recommended that subnet selections span availabitly zones (AZs).   For example, if your VPC has 2 AZs, a private subnet ID from each respective AZ would be ideal targets.

Also, a security group is created granting access from specific CIDRs.

## Minimum Required Configuration

Substitute the details below for your cluster.

```terraform
module "efs01" {
  source        = "./relative/path/to/modules/efs/filesystem"
  name          = "efs01"
  # kms_key_arn can be set to "NO_ENCRYPTION" to disable encryption
  kms_key_arn   = "arn:aws:kms:<REGION>:<ACCOUNT_ID>:key/44049bc8-9999-9999-9999-a12d4ce363ba"
  ingress_cidrs = ["10.0.0.0/24"]
  subnet_ids    = ["subnet-XXXXXXXX", "subnet-YYYYYYYY"]
}
```

## Inputs and Outputs

Inputs and outputs are generated with [terraform-docs](https://github.com/segmentio/terraform-docs)

```bash
terraform-docs markdown table ./
```

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ingress\_cidrs | List of CIDRs to be allowed TCP access to the file system. | `list(string)` | n/a | yes |
| kms\_key\_arn | KMS Key ARN for encryption.  Set to NO\_ENCRYPTION to disable encryption. | `string` | n/a | yes |
| lifecycle\_policy | Transition files to EFS IA storage class.  Disabled if empty (default).  Valid values: AFTER\_7\_DAYS, AFTER\_14\_DAYS, AFTER\_30\_DAYS, AFTER\_60\_DAYS, or AFTER\_90\_DAYS | `string` | `""` | no |
| name | File System Name | `string` | n/a | yes |
| performance\_mode | File system performance mode.  generalPurpose or maxIO. | `string` | `"generalPurpose"` | no |
| provisioned\_throughput\_in\_mibps | Network capacity in MiB/s.  Only valid with throughput\_mode set to provisioned.  1-1024 | `number` | `1` | no |
| security\_group\_ids | List of additional security group IDs to associate with file system. | `list(string)` | `[]` | no |
| subnet\_ids | List of subnet IDs to deploy EFS endpoints in.  Private or Private Data subnets are highly recommended. | `list(string)` | n/a | yes |
| tags | Tags to apply to all module resources. | `map` | `{}` | no |
| throughput\_mode | Throughput Mode, defaults to busting.  Valid valids are busrting and provisioned.  Provisioned requires provisioned\_throughput\_in\_mipbs set. | `string` | `"bursting"` | no |

### Outputs

| Name | Description |
|------|-------------|
| arn | File system ARN |
| dns\_name | File system DNS Name |
| id | File system ID |
| mount\_target\_ip | IP in each respective subnet/AZ for mounting |
| security\_group\_id | Security group ID allowing ingress to mount targets |
