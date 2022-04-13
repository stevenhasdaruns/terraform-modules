# Module - Batch Compute Environment

## Description

This module creates a AWS Batch Compute Environment.  It can be configured for on demand or spot usage.

- [Module - Batch Compute Environment](#module---batch-compute-environment)
  - [Description](#description)
  - [Storage Customizations](#storage-customizations)
    - [Container Volume Storage Limit](#container-volume-storage-limit)
    - [Scratch EBS Volume](#scratch-ebs-volume)
    - [EFS Volume](#efs-volume)
  - [Additional Considerations](#additional-considerations)
  - [Minimum Required Configuration](#minimum-required-configuration)
  - [Inputs and Outputs](#inputs-and-outputs)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

## Storage Customizations

### Container Volume Storage Limit

The default container volume storage limit in ECS is 10 GB.  This may be insufficient for containers with large package installs or containers that pull external data on startup.  This value [can be increased](https://aws.amazon.com/premiumsupport/knowledge-center/increase-default-ecs-docker-limit/) via module variables.

### Scratch EBS Volume

An additional EBS volume can be attached, formatted (ext4), and mounted (defaults to `/scratch`).  This volume can be exposed to the container in the job definition.  Review variable definitions for usage.

### EFS Volume

An pre-existing EFS volume can be mounted on the EC2 host instance `/efs` directory by specifying the file system ID in the `efs_file_system_id` variable.

## Additional Considerations

- Some updates will require all queues be disconnected from the compute environment.
- The batch service role may create additional launch templates.  Those launch templates are not used by this module and can be ignored.
- Launch template versions are explicit (number) rather than `$Latest`.  In module testing the `$Latest` consistently used the `$Default` which was version 1.  This is mentioned only for explanation - No action is necessary.

## Minimum Required Configuration

```terraform
module "batch_on_demand" {
  source                 = "../relative/path/to/modules/batch/compute-environment"
  name                   = "batch_on_demand"
  compute_type           = "EC2"
  instance_profile_arn   = arn:aws:iam::999999999999:instance-profile/batch-instance
  service_role_batch_arn = arn:aws:iam::999999999999:role/batch-service-role
  subnet_ids             = ["subnet-XXXXXXXX", "subnet-YYYYYYYY"]
  vpc_id                 = "vpc-XXXXXXXX"
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
| ami\_owners | List of owners for source ECS AMI. | `list` | <code><pre>[<br>  "amazon"<br>]<br></pre></code> | no |
| bid\_percentage | Integer of minimum percentage that a Spot Instance price must be when compared to on demand.  Example: A value of 20 would require the spot price be lower than 20% the current on demand price. | `string` | `"100"` | no |
| compute\_type | EC2 or SPOT. | `string` | `"EC2"` | no |
| custom\_ami | Optional string for custom AMI.  If omitted, latest ECS AMI in the current region will be used. | `string` | `""` | no |
| docker\_expand\_volume | Optionally expand docker volume.  AWS default is 10GB, some containers may require more storage. | `bool` | `false` | no |
| docker\_max\_container\_size | If docker\_expand\_volume is true, containers will allocate this amount of storage (GB) when launched. | `number` | `20` | no |
| ec2\_key\_pair | Optional keypair to connect to the instance with.  Consider SSM as an alternative. | `string` | `""` | no |
| efs\_file\_system\_id | Optional EFS file system ID to mount on the EC2 instance.  Mounted on /efs. | `string` | `""` | no |
| instance\_profile\_arn | ARN of the EC2 instance profile for compute instances. | `string` | n/a | yes |
| instance\_types | Optional list of instance types. | `list` | <code><pre>[<br>  "optimal"<br>]<br></pre></code> | no |
| max\_vcpus | Max vCPUs.  Default 2 for m4.large. | `string` | `8` | no |
| min\_vcpus | Minimum vCPUs.  > 0 causes instances to always be running. | `string` | `0` | no |
| name | Compute environment name. | `string` | n/a | yes |
| scratch\_volume\_device\_name | Device name for scratch space volume - E.g. /dev/xvdf | `string` | `"/dev/xvdf"` | no |
| scratch\_volume\_ebs\_size | Size in GB of scratch space volume. | `number` | `100` | no |
| scratch\_volume\_enabled | Create additional EBS volume for scratch space. | `bool` | `false` | no |
| scratch\_volume\_mount\_point | Directory to mount additional volume - E.g. /scratch | `string` | `"/scratch"` | no |
| security\_group\_ids | List of additional security groups to associate with cluster instances.  If empty, default security group will be added. | `list` | <code><pre>[<br>  ""<br>]<br></pre></code> | no |
| service\_role\_batch\_arn | ARN of the batch service role. | `string` | n/a | yes |
| service\_role\_spot\_fleet\_arn | ARN of the spot fleet service role. | `string` | `""` | no |
| subnet\_ids | List of subnets compute environment instances will be deployed in. | `list` | n/a | yes |
| tags | Tags to apply to all module resources. | `map` | `{}` | no |
| type | MANAGED or UNMANAGED. | `string` | `"MANAGED"` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the compute environment. |
| ecs\_cluster\_arn | ARN of the ECS cluster for the compute environment. |
