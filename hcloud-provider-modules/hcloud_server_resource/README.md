## Provider Resource: hcloud_server

Creates a virtual compute server on Hetzner Cloud.

## Basic Example: Create a Gateway Server VM

In Hetzner virtual private network, you need Gateway Server VM that has two network interfaces (one public, and the other private) 
to act as a NAT Internet gateway provider for the VPC.

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-server
  namespace: flux-system
spec:
  path: hcloud_server_resource
  values:
    hcloud_servers: {
      gateway-vm01: {
        name: "gateway-vm01",
        VPC_ID: 11833724,
        VPC_CIDR: "10.10.0.0/16",
        compute_flavor: "cx23",
        machine_image: "rocky-8",
        zone_location: "hel1",
        HOST_SSH_KEY: "iac-automation-sa", #Can be the hcloud_ssh_key id or name
        #enable_public_ip: true, #when the server_role is cloudinit-gateway, enable_public_ip is automatically set to true
        server_role: "cloudinit-gateway", #sets up cloud-init config for gateway
        private_ip: "10.10.30.5"
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
    name: hcloud-server-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Basic Example: Create a Server VM with a Public IP

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-server
  namespace: flux-system
spec:
  path: hcloud_server_resource
  values:
    hcloud_servers: {
      public-vm01: {
        name: "public-vm01",
        VPC_ID: 11833724,
        compute_flavor: "cx23",
        machine_image: "rocky-8",
        zone_location: "hel1",
        HOST_SSH_KEY: "iac-automation-sa", #Can be the hcloud_ssh_key id or name
        enable_public_ip: true, #when the server_role is cloudinit-gateway, enable_public_ip is automatically set to true
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
    name: hcloud-server-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Advanced Example: Create a Gateway Server VM and a Private VM with NAT cloud-init configuration

To enable the NAT cloud-init configuration during the VM creation, we will leverage the `server_role = cloudinit-nat`.

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-server
  namespace: flux-system
spec:
  path: hcloud_server_resource
  values:
    hcloud_servers: {
      gateway-vm01: {
        name: "gateway-vm01",
        VPC_ID: 11833724,
        VPC_CIDR: "10.10.0.0/16",
        compute_flavor: "cx23",
        machine_image: "rocky-8",
        zone_location: "hel1",
        HOST_SSH_KEY: "iac-automation-sa", #Can be the hcloud_ssh_key id or name
        #enable_public_ip: true, #when the server_role is cloudinit-gateway, enable_public_ip is automatically set to true
        server_role: "cloudinit-gateway", #sets up cloud-init config for gateway
        private_ip: "10.10.30.5"
      },
      private-vm01: {
        name: "private-vm01",
        VPC_ID: 11833724,
        compute_flavor: "cx23",
        machine_image: "rocky-8",
        zone_location: "hel1",
        HOST_SSH_KEY: "iac-automation-sa", #Can be the hcloud_ssh_key id or name
        server_role:  "cloudinit-nat", #sets up cloud-init config for NAT
        private_ip: "10.10.30.10",
        vpc_gateway_ip: "10.10.0.1" #The VPC network gateway IP to use for NAT. Usually the first IP from the VPC CIDR
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
    name: hcloud-server-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#attributes-reference)

## References
- [Terraform HCLOUD_SERVER](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

