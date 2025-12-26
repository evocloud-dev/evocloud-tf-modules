## Provider Resource: aws_security_group

Creates an AWS VPC resource.

## Depends On:

- `aws_vpc_resource`

## Basic Example: Create ingress group rules with default egress security group rule

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-security-group
  namespace: flux-system
spec:
  path: aws_security_group
  values:
    VPC_ID: "vpc-0bdcab4d22b8c8975" #Can reference value from aws_vpc output
    enable_default_egress: true
    security_groups: {
      main-vpc-sg: {
        name: "main-vpc-sg",
        description: "Security Group Attached to the VPC",
        ingress_rules: [
          {
            from_port: 22,
            to_port: 22,
            protocol: "tcp",
            cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          },
          {
            from_port: 30000,
            to_port: 32767,
            protocol: "tcp",
            cidr_blocks: ["0.0.0.0/0"],
            description: "Kubernetes default NodePort range"
          }
        ]
      }
    } 
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-security-group-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Advanced Example: Create ingress group rules and an egress security group rule

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-security-group
  namespace: flux-system
spec:
  path: aws_security_group
  values:
    VPC_ID: "vpc-0bdcab4d22b8c8975" #Can reference value from aws_vpc output
    security_groups: {
      main-vpc-sg: {                 
        name: "main-vpc-sg",
        description: "Security Group Attached to the VPC",
        ingress_rules: [
          {
            from_port: 22,
            to_port: 22,
            protocol: "tcp",
            cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          },
          {
            from_port: 30000,
            to_port: 32767,
            protocol: "tcp",
            cidr_blocks: ["0.0.0.0/0"],
            description: "Kubernetes default NodePort range"
          }
        ],
        egress_rules: [
          {
            from_port: 0,
            to_port: 0,
            protocol: "-1",
            cidr_blocks: ["0.0.0.0/0"],
            description: "Allow all outbound (default)"             
          }
        ]
      }
    } 
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-security-group-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#attribute-reference)

## References
- [Terraform AWS_ROUTE_TABLE_ASSOCIATION](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)
- [AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

