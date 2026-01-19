## Provider Resource: hcloud_snapshot

Builds a Talos Machine Image Snapshot.

## Basic Example: Build a Talos Machine Image with minimal variable set.

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-talos-ami
  namespace: flux-system
spec:
  path: hcloud_talos_ami
  values:
    talos_version: "1.12.1"
    talos_schematic_id: "86a5d7c9beb23b4aea2777e44ca06c8c2ceea8a874ccd2b9a6743c4f734329e0"
    zone_location: "hel1"
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 20s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-talos-ami-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: hcloud-credentials
```

## Advanced Example: Build a Talos Machine Image with all variable set.

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-talos-ami
  namespace: flux-system
spec:
  path: hcloud_talos_ami
  values:
    talos_version: "1.12.1"
    talos_schematic_id: "86a5d7c9beb23b4aea2777e44ca06c8c2ceea8a874ccd2b9a6743c4f734329e0"
    zone_location: "hel1"
    compute_flavor: "cx23"
    machine_image: "debian-12"
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 20s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-talos-ami-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced below:
- [hcloud_snapshot](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/snapshot#argument-reference)
- [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#argument-reference)
- [hcloud_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced below:
- [hcloud_snapshot](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/snapshot#attributes-reference)
- [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#attribute-reference)
- [hcloud_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key#attribute-reference)

## References

- [Terraform HCLOUD_SNAPSHOT](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/snapshot)
- [Terraform TLS_PRIVATE_KEY](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)
- [Terraform HCLOUD_SSH_KEY](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key)


## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

