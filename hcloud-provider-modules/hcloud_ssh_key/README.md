## Provider Resource: hcloud_ssh_key and tls_private_key

Creates an openssh key pair with tls_private_key resource and converts it into hcloud_ssh_key resource.

## Basic Example: Create a openssh key pair and converts it into hcloud_ssh_key

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-sshkeys
  namespace: flux-system
spec:
  path: hcloud_ssh_key
  values:
    ssh_key_name: "iac-automation-sa"
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  retryInterval: 20s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-ssh-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced below:
- [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#argument-reference)
- [hcloud_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced below:
- [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#attribute-reference)
- [hcloud_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key#attribute-reference)

## References

- [Terraform TLS_PRIVATE_KEY](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)
- [Terraform HCLOUD_SSH_KEY](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key)


## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

