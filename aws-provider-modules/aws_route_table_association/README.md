## Provider Resource: aws_route_table_association

AWS_ROUTE_TABLE_ASSOCIATION to associate a subnet to a public or private route.

## Depends On:

- `aws_route_table`
- `aws_subnet_resource`

## Basic Example: Create a subnet association to a private route

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-subnet-association
  namespace: flux-system
spec:
  path: aws_route_table_association
  values:
    PRIVATE_ROUTE_TABLE_ID: "rtb-075e82ccdbf46c0fc" #Can reference value from aws_route_table output
    PRIVATE_SUBNET_IDS: {
      admin-subnet-us-east-2a: "subnet-00bf79f71242c41e5",
      admin-subnet-us-east-2b: "subnet-01d6f441ca830400d",
      admin-subnet-us-east-2c: "subnet-0f2d9cbba01015b34",
      backend-subnet-us-east-2a: "subnet-0920691939006f9bd",
      backend-subnet-us-east-2b: "subnet-0c7d732b16f3b3ce0",
      backend-subnet-us-east-2c: "subnet-04372ab36dd27e795"
    } #Can reference value from aws_subnet_resource output
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-subnet-association-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials
```

## Advanced Example: Create 3 subnets in all 3 Availability Zones

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: aws-subnet-association
  namespace: flux-system
spec:
  path: aws_route_table_association
  values:
    PRIVATE_ROUTE_TABLE_ID: "rtb-075e82ccdbf46c0fc" #Can reference value from aws_route_table output
    PRIVATE_SUBNET_IDS: {
      admin-subnet-us-east-2a: "subnet-00bf79f71242c41e5",
      admin-subnet-us-east-2b: "subnet-01d6f441ca830400d",
      admin-subnet-us-east-2c: "subnet-0f2d9cbba01015b34",
      backend-subnet-us-east-2a: "subnet-0920691939006f9bd",
      backend-subnet-us-east-2b: "subnet-0c7d732b16f3b3ce0",
      backend-subnet-us-east-2c: "subnet-04372ab36dd27e795"
    }  #Can reference value from aws_subnet_resource output
    PUBLIC_ROUTE_TABLE_ID : "rtb-044b8960a4ea56028"
    PUBLIC_SUBNET_IDS: {
      dmz-subnet-us-east-2a: "subnet-0e21ba65215446cca",
      dmz-subnet-us-east-2b: "subnet-0534421be0c4fc943",
      dmz-subnet-us-east-2c: "subnet-0c5d66b5b3966bab9"
    }#Can reference value from aws_subnet_resource output

  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-aws
  approvePlan: auto
  retryInterval: 20s
  interval: 1h0m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: aws-subnet-association-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: aws-credentials
```

## Argument Reference

This resource supports the following arguments referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#argument-reference)

## Attribute Reference

This resource supports the following attributes referenced [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#attribute-reference)

## References
- [Terraform AWS_ROUTE_TABLE_ASSOCIATION](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)
- [AWS_VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

