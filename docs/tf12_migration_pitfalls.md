# Terraform 12 to 0.13+ Migration Pitfalls

- [Terraform 12 to 0.13+ Migration Pitfalls](#terraform-12-to-013-migration-pitfalls--gotchas)
  - [Overview](#overview)
  - [Provider Declarations](#provider-declarations)
  - [template_file provider](#template_file-provider)

## Overview

Terraform provides upgrade instructions on each major release.  This document highlights some of the upgrade issues you may encounter that are worth more careful review in the Terraform upgrade guides.

Upgrade Guide Quick Links

- [0.13 => 0.14](https://www.terraform.io/upgrade-guides/0-14.html)
- [0.12 => 0.13](https://www.terraform.io/upgrade-guides/0-13.html)
- [0.11 => 0.12](https://www.terraform.io/upgrade-guides/0-12.html)

## Provider Declarations

Terraform 0.13 updated the way it handles the provider configuration.  Specifically, review the [Explicit Provider Source Locations](https://www.terraform.io/upgrade-guides/0-13.html#explicit-provider-source-locations) if using providers outside the HashiCorp ecosystem - newrelic, as an example.

Also, nested providers' use has changed within modules that have `count | depends on | for_each` applied.  For an in depth read, review the [Legacy Shared Modules with Provider Configurations](https://www.terraform.io/docs/modules/providers.html#legacy-shared-modules-with-provider-configurations) section of the Terraform documentation.  In summary, if you were previously passing `providers = ` to modules, and you'd like to leverage looping, review the examples on the previously linked documentation.

## Provider Deprication - template_file

Prior to Terraform 12, the [template_file provider](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) was used to read and render templates with variable interpolation.  This definition would have looked like the following example:

Pre Terraform 0.12 Usage

```HCL
data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
  vars = {
    consul_address = "${aws_instance.consul.private_ip}"
  }
}
```

In Terraform 0.12, the [templatefile()](https://www.terraform.io/docs/configuration/functions/templatefile.html) function was introduced.  This function should be used in place of the previous `template_file` provider.   After 0.13, using the deprecated `template_file` provider created excessive output during plan and apply operations - [Source](https://github.com/hashicorp/terraform/issues/26290#issuecomment-698571062), making it more important to refresh your terraform with the `templatefile()` function.
