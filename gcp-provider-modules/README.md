## Google Cloud Provider Modules

This repository contains terraform/tofu modules for deploying infrastructure resources on Google Cloud Platform (GCP).

## Requirements

- EvoCloud evok8s cluster 
- kubectl CLI

## Setup EvoCloud with GCP

To interact with GCP, we need to create a Kubernetes secret resource that contains the GCP credentials.json file.
Generate first the JSON file with the GCP service account credentials, then to create the Kubernetes secret run the following:

```
kubectl create secret generic gcp-credentials \
--from-file=credentials.json=/home/mlkroot/EVOCLOUD/Keys/geanttech-evocloud-aa3aa17df584.json \
--namespace flux-system
```

kubectl create secret generic gcp-credentials \
--from-file=credentials.json=./my-gcp-credentials.json \
--namespace flux-system

And during the module deployment the Kubernetes secret containing the AWS credentials can be referenced as such:

```yaml
spec:
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
  interval: 10m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: main-vpc-outputs
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
