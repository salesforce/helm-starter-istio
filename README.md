# helm-starter-istio

An Istio starter template for Helm.

## Features

* Simplified Istio ingress configuration
* Simplified Istio port configuration
* ConfigMap driven by `values.yaml`, to facilitate easy Helm value overriding
* Creates the following Kubernetes and Istio objects
** Service
** Deployment
** ConfigMap
** VirtualService
** DestinationRule

## Usage

```sh
# Create a helm chart from the starter
> helm create NAME --starter helm-starter-istio

# Deploy the helm chart to kubernetes
> helm template NAME | kubectl -apply -f -
```
