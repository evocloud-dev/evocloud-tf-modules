## AWS Cloud Provider Modules

This repository contains terraform/tofu modules for deploying infrastructure resources on AWS Cloud Platform (AWS).

## Requirements

- EvoCloud evok8s cluster
- kubectl CLI

## Setup the OCI Repository

The tf-modules are contained in an OCI image, and we need to create a OCIRepository to reference it.

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: OCIRepository
metadata:
  name: evocloud-tf-modules-aws
  namespace: flux-system
spec:
  interval: 1h
  provider: generic
  ref:
    tag: 0.1.0
  timeout: 60s
  url: oci://ghcr.io/evocloud-dev/oci/evocloud-tf-modules-aws
```

## Setup EvoCloud with AWS

To interact with AWS, we need to create a Kubernetes secret resource that contains the AWS credentials:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-credentials
  namespace: flux-system
type: Opaque
stringData:
  AWS_ACCESS_KEY_ID: Axxxxxxxxxxxxxxxxxxx
  AWS_SECRET_ACCESS_KEY: qxxxxxxxxxxxxxxxxxxxxxxxxx
  AWS_REGION: us-east-2 # the default region you want
```

And during the module deployment the Kubernetes secret containing the AWS credentials can be referenced as such:

```yaml
spec:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

Here is a full example on how to create an AWS VPC resource using the credentials provided:

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-vpc
  namespace: flux-system
spec:
  path: aws_vpc_resource
  values:
    cidr_block: "10.0.0.0/24"
    enable_dns_support: true
    enable_dns_hostnames: true
    enable_network_address_usage_metrics: false
    tags:
      Environment: Dev
      Name: main-vpc
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-vpc-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```
