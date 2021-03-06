# helm-starter-istio

An Istio starter template for Helm.

Stop fiddling with Istio and Kubernetes YAML and start building. This starter sets up everything you need to get a container
running in Istio correctly the first time.

## Features

* Fastest way to get a new service into the Istio mesh
* Simplified Istio ingress configuration
* Simplified Istio port configuration
* ConfigMap driven by `values.yaml`, to facilitate easy Helm value overriding
* Creates the following Kubernetes and Istio objects
  * Service
  * Deployment
  * ConfigMap (optional)
  * VirtualService
  * DestinationRule
  * PodDisruptionBudget
  * HorizontalPodAutoscaler (optional)
  * ServiceAccount (optional)
  
## Installation

* Clone into `$helm-home/starters` or,
* Install with the [`helm-starter`](https://github.com/salesforce/helm-starter) plugin.
  * `helm plugin install https://github.com/salesforce/helm-starter.git`
  * `helm starter fetch https://github.com/salesforce/helm-starter-istio.git`

## Usage

Pick the starter you want to use:

* `mesh-service` - creates a Helm chart for a mesh internal service (no ingress).
* `ingress-service` - creates a Helm chart for sevice exposed through an Istio ingress gateway.
* `mesh-egress` - creates a Helm chart for configuring mesh egress policies for external systems.
* `auth-policy` - creates a Helm chart for managing authorization policy within the mesh.

```sh
# Create a helm chart from the starter
> helm create NAME --starter helm-starter-istio/[starter-name]

# Deploy the helm chart to kubernetes
> helm template NAME | kubectl -apply -f -
```

## Samples

The `samples` directory contains example `values.yaml` files for installing the
[Istio Bookinfo](https://istio.io/latest/docs/examples/bookinfo/) sample application.

### Set up Istio

The samples assume you are running Kubernetes and Istio locally using Docker
Desktop using the default profile.

```sh
> istioctl install --set profile=default --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY -y
> kubectl label namespace default istio-injection=enabled
> kubectl apply -f samples/gateway.yaml
```

### Bookinfo services

To install the Bookinfo services:

```sh
> helm template --namespace default -f samples/bookinfo-product/values.yaml ingress-service | kubectl apply -f -
> helm template --namespace default -f samples/bookinfo-details/values.yaml mesh-service | kubectl apply -f -
> helm template --namespace default -f samples/bookinfo-reviews/values.yaml mesh-service | kubectl apply -f -
```

Then navigate to <http://lvh.me/productpage>.

### Bookinfo mTLS

Enable mTLS authorization policies between the services:

```sh
> helm template --namespace default -f samples/bookinfo-auth-policy/values.yaml auth-policy | kubectl apply -f -
```

### Mesh egress

Install mesh egress configuration:

```sh
> helm template --namespace default -f samples/egress/values.yaml mesh-egress | kubectl apply -f -
```

Install a `curl` pod in Kubernetes so you have a shell to log into to try curl testing
different egress routes.

```sh
> kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/sleep/sleep.yaml
```
