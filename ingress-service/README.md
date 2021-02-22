# <CHARTNAME> Helm Chart

This Helm chart installs the <CHARTNAME> service in both Kubernetes and Istio.

## Installation

```sh
> helm template --namespace=[namespace] <CHARTNAME> | kubectl apply -f -
```

## Values.yaml

All configuration for this installation is managed in `values.yaml`. Configuration
values can be overriden individually at installation using Helm's `--set` command
line option.

### Service Identity

These three values control the names of generated Kubernetes and Istio objects,
and are used to ensure commont Kubernetes labeling. These values are used to populate
labels that allow for selecting all components of a particular system or service.

* `system`, `service`, `version` - These values describe _what_ this service and
  what it should be named. For example: `my-website`, `web-server`, `2`.

### Container Values

These settings control from where and how your service's docker image is acquired.

* `image.repository` - The docker repo and image to pull.
* `image.tag` - The docker image tag to pull.
* `image.imagePullPolicy` - Kubernetes image pull policy.

### Service Account Values

Istio request authorization requires that each service have a unique service account
identity to functuion correctly.

* `serviceAccount.name` - The Kubernetes service account your service will run under.
* `serviceAccount.create` - Optionally, this chart can generate the service account.
  If false, the service's service account must be pre-existing.

### Replica Values

These settings control service replicas, disruption budgets, and autoscaling.

* `replicaCount` - The initial number of replicas to start after installing this
  chart.
* `maxUnavailable` - The maximum number of intentionally unavailable pods as
  controlled by a `PodDisruptionBudget`.
* `autoscaling.minReplicas` - The minimum number of replicas to run under the
  control of a `HorizontalPodAutoscaler`.
* `autoscaling.maxReplicas` - The maximum number of replicas to run under the
  control of a `HorizontalPodAutoscaler`.
* `autoscaling.targetAverageCpuUtilization` - The CPU utilization target
  used by the `HorizontalPodAutoscaler` to make autoscale decisions.

### Port Values

These settings expose network ports through Kubernetes and Istio. Ports are
listed as an array.

* `ports.name` - The unique name for this port. Port names _should_ comply
  with Istio port naming standards by including their protocol in the name.
  Protocol detection works for HTTP and HTTP/2, but other protocols need help.
  <https://istio.io/latest/docs/ops/configuration/traffic-management/protocol-selection/>
* `ports.port` - The port number presented _outside_ your container. This is the
  port Istio and Kubernetes will use when referring to your service's port.
* `ports.targetPort` - The internal port number _inside_ your container. Kubernetes
  will map the outside port to the inside port when routing traffic to your container.

### Ingress Values

These settings configure how Istio exposes your service throug an Istio ingress
gateway. They assume the Istio ingress gateway is installed, and an Istio
`Gateway` object has been configured in the mesh.

* `ingressGateway.name` - The namespace/name of the Istio `Gateway` object through
  which this service should be exposed.
* `ingressGateway.host` - Bind this service's ingress configuration to a hostname.
* `ingressGateway.matchPrefix` - A string array of REST route prefixes this service
  matches. gRPC services are matched as `/protoNamespace/protoService/*`.

### Resiliency Values

These settings control Istio's resiliency configuration for your service. This
includes timeouts, circuit breakers, retires, and outlier detection.

* `overallTimeout` - The "top-level" timeout enforced when clients call your
  service. This timeout is inclusive of retries.
* `retries.*` - Istio configuration for client retry policy. See
  [Istio retry documentation](https://istio.io/latest/docs/reference/config/networking/virtual-service/#HTTPRetry) for values. Note: if retries are configured,
  an `overallTimeout` greater than the sum of all retries must be used.
* `outlierDetection.*` - Istio configuration for client circuit breaker configuration.
  See [Istio outlier detection documentation](https://istio.io/latest/docs/reference/config/networking/destination-rule/#OutlierDetection) for details.

### Kubernetes Pod Values

These settings configure your service's resource constraints and health check
probes. They ensure your service is a well behaved consumer of shared Kubernetes
resources.

* `resources.*` - Kubernetes resource request and limit configuration. See
  [Kubernetes resource documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for values.
* `probes.*` - Kubernetes probe configuration. See [Kubernetes probe documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) for values.

### ConfigMap Values

These optional settings are used to populate and mount a configmap for your
service. When the generated config map changes, the associated service is automatically
resterted using a rolling restart. Generating the configmap from Helm chart values
is useful because it allows you to modify config map values durring installation
using Helm `--set` directives.

* `configMap.mountPath` - The directory inside your pod to mount the config map.
* `configMap.fileName` - The file name of the config map, when mounted in the pod.
* `configMap.content.*` - YAML keys and values under `content` are copied verbatim
  into the configmap's content.
