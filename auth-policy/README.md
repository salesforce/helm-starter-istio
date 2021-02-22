# <CHARTNAME> Istio Authorization Policy

This Helm chart installs <CHARTNAME> Istio authorization policy into an Istio
service mesh.

## Installation

The installation namespace is important when installing this helm chart. It's
value sets the Kubernetes namespace for all settings in this chart.

```sh
> helm template --namespace=[namespace] <CHARTNAME> | kubectl apply -f -
```

## Values.yaml

All configuration for this policy is managed in `values.yaml`. Configuration
values can be overriden individually at installation using Helm's `--set` command
line option.

### Namespace Policy

These settings control the overall security posture of this chart's installed
namespace.

* `namespacePolicy.defaultDeny` - When set to true, all requests to services
  in this namespace are denied by default, unless explicitly authorized by
  a specific policy.
* `namespacePolicy.mtlsMode` - This setting controls how strictly Istio enforces
  mTLS requirements within this namespace. Values are `STRICT` and `PERMISSIVE`.

### Authorization Policy

This section contains a list of services and their authorization policies.
Authorization policy enumerates which services are allowed to call each other,
and on which paths.

* `authorizations.[serviceName].matchLabels` - A list of label matches used to
  identify the service this policy expression applies to. i.e. the request
  destination.
* `authorizations.[serviceName].rules` - A list of `principals/paths` pairs used
  to identify which calling principals are allowed to access specific paths of
  the service.
  * `allowPrincipals` - A list of Kubernetes service accounts in `namespace/name`
    format allowed to access this service. All service instances operating under
    this service account are treated the same for authorization decisions.
  * `paths` - A list of REST paths authorized principals are allowed to call.
    gRPC services are matched as `/protoNamespace/protoService/*`.
