## Provider Resources: hcloud_volume and hcloud_volume_attachment

Creates one or more extra volumes and attaches it to a specific server on Hetzner Cloud.

## Basic Example: Create extra volumes and attach each of them to a specific hcloud_server

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-volume
  namespace: flux-system
spec:
  path: hcloud_volume_resource
  values:
    extra_volumes: {
      #extra volume for vm named privatevm-01              
      privatevm-01-vol: {
        volume_name: "privatevm-01-vol",
        volume_size: 50,
        disk_format: "xfs", # xfs or ext4
        zone_location: "hel1",
        attach_to: "privatevm-01",
        automount: false #Attaches the volume but does not automount it
      },
      #extra volume for vm named privatevm-02 
      privatevm-02-vol: {
        volume_name: "privatevm-02-vol",
        volume_size: 50,
        disk_format: "xfs", # xfs or ext4
        zone_location: "hel1",
        attach_to: "privatevm-02",
        automount: true #Automount the volume upon attaching it
      }
    }
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 10s
  interval: 2m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-volume-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced below:
- [hcloud_volume](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume#argument-reference)
- [hcloud_volume_attachment](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume_attachment#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced below:
- [hcloud_volume](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume#attribute-reference)
- [hcloud_volume_attachment](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume_attachment#attribute-reference)

## References

- [Terraform HCLOUD_VOLUME](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume)
- [Terraform HCLOUD_VOLUME_ATTACHMENT](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume_attachment)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

