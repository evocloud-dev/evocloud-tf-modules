## Provider Resource: hcloud_network

Creates a Hetzner Cloud Network VPC.

## Basic Example: Create a basic VPC

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-vpc
  namespace: flux-system
spec:
  path: hcloud_network_vpc
  values:
    cidr_block: "10.10.0.0/16"
    vpc_name: evocloud-vpc
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-vpc-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Advanced Example: Create a VPC with labels

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-vpc
  namespace: flux-system
spec:
  path: hcloud_network_vpc
  values:
    cidr_block: "10.10.0.0/16"
    vpc_name: evocloud-vpc
    labels:
      Environment: Dev
      Name: main-vpc
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-vpc-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network#attributes-reference) 

## References
- [Terraform HCLOUD_NETWORK](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

