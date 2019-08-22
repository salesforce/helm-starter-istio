# helm-starter-istio

An Istio starter template for Helm.

## Features

* Fastest way to get a new service into the Istio mesh
* Simplified Istio ingress configuration
* Simplified Istio port configuration
* ConfigMap driven by `values.yaml`, to facilitate easy Helm value overriding
* Creates the following Kubernetes and Istio objects
  * Service
  * Deployment
  * ConfigMap
  * VirtualService
  * DestinationRule
  
## Installation

* Clone into `~/.helm/starters` or,
* Install with the [`helm-starter`](https://github.com/salesforce/helm-starter) plugin.
  * `helm starter fetch https://github.com/salesforce/helm-starter-istio.git`

## Usage

```sh
# Create a helm chart from the starter
> helm create NAME --starter helm-starter-istio

# Deploy the helm chart to kubernetes
> helm template NAME | kubectl -apply -f -
```
