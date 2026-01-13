## Provider Resource: hcloud_network_subnet

Creates a Hetzner Cloud Network Subnet.

## Basic Example: Create a basic Subnet

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-subnet
  namespace: flux-system
spec:
  path: hcloud_network_subnet
  values:
    VPC_ID: 11824253
    VPC_CIDR_BLOCK: "10.10.0.0/16"
    subnets_configs: [
      {
        subnet_name: "admin-subnet",
        network_tier: "cloud",
        network_zone: "eu-central",
        subnet_number: 10,
        subnet_newbits: 8
      }
    ]
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-subnet-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Advanced Example: Create multiple Subnets

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-subnet
  namespace: flux-system
spec:
  path: hcloud_network_subnet
  values:
    VPC_ID: 11824253
    VPC_CIDR_BLOCK: "10.10.0.0/16"
    subnets_configs: [
      {
        subnet_name: "admin-subnet",
        network_tier: "cloud",
        network_zone: "eu-central",
        subnet_number: 10,
        subnet_newbits: 8
      },
      {
        subnet_name: "backend-subnet",
        network_tier: "cloud",
        network_zone: "eu-central",
        subnet_number: 20,
        subnet_newbits: 8
      },
      {
        subnet_name: "dmz-subnet",
        network_tier: "cloud",
        network_zone: "eu-central",
        subnet_number: 30,
        subnet_newbits: 8
      }
    ]
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-subnet-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet#attributes-reference)

## References
- [Terraform HCLOUD_NETWORK_SUBNET](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

