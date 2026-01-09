## Provider Resource: aws_s3_bucket

Creates AWS Public or Private S3 Bucket.

## Depends On:

- `none`

## Basic Example: Create a private S3 Bucket

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-s3-bucket
  namespace: flux-system
spec:
  path: aws_gateway_resource
  values:
    bucket_name: "my-private-bucket-unique-name" 
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 10s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-bucket-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Basic Example: Create a public S3 Bucket

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-s3-bucket
  namespace: flux-system
spec:
  path: aws_gateway_resource
  values:
    bucket_name: "my-public-bucket-unique-name"
    enable_public_access: true
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 10s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-bucket-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced below:
- [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#argument-reference)
- [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced below:
- [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#attribute-reference)
- [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#attribute-reference)

## References
- [Terraform AWS_S3_BUCKET](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Terraform AWS_S3_BUCKET_POLICY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

