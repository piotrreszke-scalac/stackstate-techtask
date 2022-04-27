# StackState tech task solution

Timeboxed this to ~3 days. Still needs a lot of work to be `production grade`, but I hope this answer questions you might have about me.

### Rationale
Based monitoring solution on Helm based Prometheus Operator - de facto standard.  It comes with ton of alerts and dashboards out of the box.
Combined this with blackbox monitoring to define `contract` what needs to be running and monitored.
Installed couple of exporters to get deeper insight about our services.

### Requirements to have this running
- kubectl
- terraform
- helm 3
- aws profile configured

### How to apply
- `terraform init`, `terraform apply` inside `infra` dir
- run `./apply.sh` in root dir of this repo

### Assumptions
- sock-shop app comes as-is (no modifications to be open for 'future patches')
- prepared for GitOps integration with ArgoCD/Flux, whatever other tool you want. `apply.sh` script is using `kubeconfig` file created by terraform to access cluster and configure stuff.
- helm template over helm install - used Helm as manifest generation tool for easier migration to GitOps solution

### Problems encountered
- rabbitmq metrics - rabbitmq container from sock-shop contains sidecar exporter, but pod expose wrong port so it's unusable. RabbitMQ itself is in old version that doesn't yet expose metrics. Installed separate rabbitmq exporter and exposed RabbitMQ management plugin

### What is missing
- alerting means (IM/telephone/email)
- secrets management
- mongodb exporter can support only one mongodb target and sockshop contains 3 of them. Multiplying it is trivial, so didn't waste time on this

### How this could be improved:
- blackbox monitoring should be implemented on independent infrastructure or external service should be used for this,
- Mysql exporter
- Cloudwatch integration for AWS infra monitoring
- no logs management
- no tracing
- JMX exporting - would have to modify JVM params and images to add Java Agent to JVM
