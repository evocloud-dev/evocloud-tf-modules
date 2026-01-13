## Provider Resource: hcloud_network_route

Creates a Hetzner Cloud Network Route.

## Basic Example: Create a basic Route

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-route
  namespace: flux-system
spec:
  path: hcloud_network_route
  values:
    VPC_ID: 11824253
    destination_net_cidr: "0.0.0.0/0"
    nat_host_ip: "10.10.30.5"
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-route-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_route#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_route#attributes-reference)

## References
- [Terraform HCLOUD_NETWORK_ROUTE](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_route)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

