# evocloud-tf-modules
Terraform resources for various cloud/infra providers.

## Flux command for pushing OCI Artifacts:

```
flux push artifact oci://ghcr.io/stefanprodan/manifests/podinfo:0.1.0 \
  --path="./kustomize" \
  --source="$(git config --get remote.origin.url)" \
  --revision="$(git branch --show-current)@sha1:$(git rev-parse HEAD)"
```

Example command for pushing the `evocloud-tf-modules-aws`

```
flux push artifact oci://ghcr.io/evocloud-dev/oci/evocloud-tf-modules:0.1.2 \
  --path="./aws-provider-modules" \
  --source="https://github.com/evocloud-dev/evocloud-tf-modules.git" \
  --revision="main@sha1:38e3e2f15657bddcceb993e8eb253e5a2a7e0b3b"
```
