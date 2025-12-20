## Provider Resource: aws_vpc

Creates an AWS VPC resource.

## Example Usage

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha1
kind: Terraform
metadata:
  name: aws-vpc
  namespace: flux-system
spec:
  path: aws_vpc_resource
  values:
    bucket: my-tf-test-bucket
    tags:
      Environment: Dev
      Name: My bucket
  sourceRef:
    kind: OCIRepository
    name: aws-provider-modules
  approvePlan: auto
  interval: 1h0m
  retryInterval: 20s
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#attribute-reference) 

## References
[Terraform AWS_VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
[AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

