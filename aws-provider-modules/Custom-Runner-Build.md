## Steps for building a custom runner image

To build a custom runner image, you need a Dockerfile that extends the base image and that adds Terraform and any additional required tooling or CLIs.

## Prerequisites

You will need the following prerequisites to build the runner image:

- Docker or any container runtime
- Git 

## Steps for building a custom image

1. Create a Dockerfile that extends the base tofu-controller image, then add Terraform and any additional required tooling. Here is an example:

````docker
ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG TARGETARCH
ARG TF_VERSION=1.14.3

# Switch to root to have permissions for operations
USER root

ADD https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${TARGETARCH}.zip /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip
RUN unzip -q /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip -d /usr/local/bin/ && \
    rm /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip && \
    chmod +x /usr/local/bin/terraform

# Switch back to the non-root user after operations
USER 65532:65532
````

2. Build the image from the Dockerfile created above:

````shell
export TF_CONTROLLER_VERSION=v0.16.0-rc.7
export TF_VERSION=1.14.3
export BASE_IMAGE=ghcr.io/flux-iac/tf-runner:${TF_CONTROLLER_VERSION}-base
export TARGETARCH=amd64
docker build --build-arg BASE_IMAGE=${BASE_IMAGE} \
             --build-arg TF_VERSION=${TF_VERSION} \
             --build-arg TARGETARCH=${TARGETARCH} \
             --tag ghcr.io/evocloud-dev/oci/evocloud-tf-runner:${TF_CONTROLLER_VERSION} .
````