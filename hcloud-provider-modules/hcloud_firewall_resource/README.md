## Provider Resource: hcloud_firewall

Creates a Hetzner Cloud Firewall Rules.

## Basic Example: Create a basic Firewall group rule

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-firewall
  namespace: flux-system
spec:
  path: hcloud_firewall_resource
  values:
    security_groups: {
      main-vpc-fw: {
        name: "main-vpc-fw",
        ingress_rules: [
          {
            protocol: "tcp",
            port: "22",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          },
          {
            protocol: "tcp",
            port: "30000-32767",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          }
        ]
      }
    }
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-firewall-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Advanced Example: Create multiple Firewall groups rule

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-firewall
  namespace: flux-system
spec:
  path: hcloud_firewall_resource
  values:
    security_groups: {
      main-vpc-fw: {
        name: "main-vpc-fw",
        ingress_rules: [
          {
            protocol: "tcp",
            port: "22",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          },
          {
            protocol: "tcp",
            port: "30000-32767",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "SSH Application Access"
          }
        ]
      },
      frontend-fw: {
        name: "frontend-fw",
        ingress_rules: [
          {
            protocol: "tcp",
            port: "80",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "HTTP Application Access"
          },
          {
            protocol: "tcp",
            port: "443",
            source_cidr_blocks: ["0.0.0.0/0"],
            description: "HTTPS Application Access"
          }
        ]
      }
    }
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-firewall-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#attributes-reference)

## References
- [Terraform HCLOUD_FIREWALL](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

