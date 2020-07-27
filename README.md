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
helm install -n cert-manager cert-manager-secret-webhook chart
```

### How to Test

Simply create a certificate and check your other namespaces. The generated secret should be recreated in all.