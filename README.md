# helm-starter-istio

An Istio starter template for Helm.

## Usage

```sh
# Create a helm chart from the starter
> helm create NAME --starter helm-starter-istio

# Deploy the helm chart to kubernetes
> helm template NAME | kubectl -apply -f -
```
