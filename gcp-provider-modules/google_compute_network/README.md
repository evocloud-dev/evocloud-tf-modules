## Provider Resource: google_compute_network

Creates a Google VPC Network resource.

## Basic Example: Create a basic GCP Virtual Network

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: gcp-compute-network
  namespace: flux-system
spec:
  path: google_compute_network
  values:
    vpc_name: "evocloud-vpc"
    vpc_routing_mode: "REGIONAL"
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-gcp
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: compute-network-outputs
    outputs:
  runnerPodTemplate:
    spec:
      env:
        - name: "GOOGLE_APPLICATION_CREDENTIALS"
          value: "/credentials/credentials.json"
        - name: "GOOGLE_PROJECT"
          value: "your_gcp_project_id"
        - name: "GOOGLE_REGION"
          value: "us-east5"
      volumeMounts:
        - name: "gcp-credentials"
          mountPath: "/credentials"
          readOnly:  true
      volumes:
        - name: "gcp-credentials"
          secret:
            secretName: "gcp-credentials"
            items:
              - key: "credentials.json"
                path: "credentials.json"
```

## Advanced Example: Create a basic GCP Virtual Network with custom MTU 

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: gcp-compute-network
  namespace: flux-system
spec:
  path: google_compute_network
  values:
    vpc_name: "evocloud-vpc"
    vpc_routing_mode: "REGIONAL"
    custom_mtu: 1460
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-gcp
  approvePlan: auto
  retryInterval: 20s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: compute-network-outputs
    outputs:
  runnerPodTemplate:
    spec:
      env:
        - name: "GOOGLE_APPLICATION_CREDENTIALS"
          value: "/credentials/credentials.json"
        - name: "GOOGLE_PROJECT"
          value: "your_gcp_project_id"
        - name: "GOOGLE_REGION"
          value: "us-east5"
      volumeMounts:
        - name: "gcp-credentials"
          mountPath: "/credentials"
          readOnly:  true
      volumes:
        - name: "gcp-credentials"
          secret:
            secretName: "gcp-credentials"
            items:
              - key: "credentials.json"
                path: "credentials.json"
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#attributes-reference)

## References
- [Terraform GOOGLE_VPC](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)


## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

