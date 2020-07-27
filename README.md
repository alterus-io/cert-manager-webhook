# Cert-Manager/Kubed Mutating Webhook

This is a mutating webhook that will add kubed annotations to generated secrets of cert-manager.

### Prerequisites

You need to have the following installed:

1. Cert Manager
2. Kubed

### How to Build

This is pre-packaged into a docker image. Simply:

```bash
docker build -t cert-manager-webhook .
```

### How to Deploy

Deploy this using the Helm chart in this repository. The chart will take care of the necessary certificate/CA generation. It is highly advised to deploy this into the same namespace as your cert-manager.

```
helm install -n cert-manager cert-manager-secret-webhook chart/
```

#### Copying to specific namespaces

To copy secrets to only specific namespaces, you can define `namespaceSelector` in your values. This will match labels of namespaces and only apply secrets to those.

For instance, you can create a `test` namespace with a `kubed-sync: "true"` label:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: test
  labels:
    kubed-sync: "true"
```

Then define that selector as the `namespaceSelector` value.

```bash
helm install -n cert-manager \
    --set namespaceSelector=kubed-sync=true \
    cert-manager-secret-webhook chart/
    
```

### How to Test

Simply create a certificate and check your other namespaces. The generated secret should be recreated.

For instance, creating this issuer/certificate in the `cert-manager` namespace:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: selfsigned-issuer
  namespace: cert-manager
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: foobar-wildcard
  namespace: cert-manager
  annotations:
    foo: bar
  labels:
    far: bat
spec:
  secretName: foobar-wildcard
  dnsNames:
  - "*.example.com"
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
    group: cert-manager.io
```


