## Hetzner Cloud Provider Modules

This repository contains terraform/tofu modules for deploying infrastructure resources on Hetzner Cloud Platform (HCLOUD).

## Requirements

- EvoCloud evok8s cluster
- kubectl CLI

## Setup EvoCloud with Hetzner

To interact with Hetzner, we need to create a Kubernetes secret resource that contains the HCLOUD Token:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: hcloud-credentials
  namespace: flux-system
type: Opaque
stringData:
  HCLOUD_TOKEN: Axxxxxxxxxxxxxxxxxxx
```

And during the module deployment the Kubernetes secret containing the hcloud credentials can be referenced as such:

```yaml
spec:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: hcloud-credentials
```

Here is a full example on how to create a Hetzner VPC resource using the credentials provided:

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
