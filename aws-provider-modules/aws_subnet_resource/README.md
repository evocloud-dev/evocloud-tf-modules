## Provider Resource: aws_subnet

Creates an AWS Subnet resource.

## Basic Example: Create 1 subnet in all 3 Availability Zones

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-subnet
  namespace: flux-system
spec:
  path: aws_subnet_resource
  values:
    VPC_ID: "vpc-0bdcab4d22b8c8975" #Can reference value from aws_vpc output
    VPC_CIDR_BLOCK: "10.10.0.0/16"  #Can reference value from aws_vpc output
    desired_subnet_names:
      - "admin-subnet"
    subnet_number:
      admin-subnet: 10
    subnet_newbits: 8
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-subnet-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Advanced Example: Create 3 subnets in all 3 Availability Zones

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-subnet
  namespace: flux-system
spec:
  path: aws_subnet_resource
  values:
    VPC_ID: "vpc-0bdcab4d22b8c8975" #Can reference value from aws_vpc output
    VPC_CIDR_BLOCK: "10.10.0.0/16"  #Can reference value from aws_vpc output
    desired_subnet_names:
      - "admin-subnet"
      - "backend-subnet"
      - "dmz-subnet"
    subnet_number:
      admin-subnet: 10
      backend-subnet: 20
      dmz-subnet: 30
    subnet_newbits: 8
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-subnet-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#attribute-reference)

## References
[Terraform AWS_VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
[AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

