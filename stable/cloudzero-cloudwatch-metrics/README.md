# CloudZero Container Metrics

A helm chart for collecting performance metrics down to the pod level.  CloudZero uses this data to calculate container cost to the pod, label, namespace, or Cluster level.  See our documentation [here](https://docs.cloudzero.com/docs/container-cost-track).

## Chart Installation

Add the CloudZero repository to Helm:

```sh
helm repo add cloudzero https://cloudzero.github.io/cloudzero-k8s-charts
```

### Prerequisite

The agent must have permission to create and write to a CloudWatch LogGroup and LogStream. Adding the AWS Managed policy `arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy` to the cluster nodes allows this. Review how you manage your nodes to see how best to attach this managed policy to the node role before installation.

### Considerations Before Installing

The agent consumes cpu and memory in relation to your cluster density. The density is defined by counting resources like number of nodes, pods, endpoints, and replicasets.  The chart values defined for CPU and Memory limits/requests are suitable for a cluster density of 300 nodes, 5000 pods, and 70,000 ReplicaSets.

Install the latest version

```sh
helm upgrade --install cloudzero-cloudwatch-metrics           \
             cloudzero/cloudzero-cloudwatch-metrics           \
             --namespace cloudzero-metrics --create-namespace \
             --set clusterName=<Your Cluster>
```

> Note: these are helm3 commands that creates a namespace for this deployment; you can also use an existing namespace.

### Sampling Frequency

 By default, the agent queries and pushes metrics every `120` seconds. This is a granular enough sampling rate to get usable metrics while keeping costs low. The potential downside is that very short lived pods will not be sampled if they are launched and terminated between sampling times. If sampling short-lived pods is desirable, the agent can be configured to record samples at shorter intervals by updating the `metricsCollectionInterval` value to one of the allowed values. **Please be aware that an increased sampling rate will cause an increase in cost, as well as increased load on the kube API**.

## Configuration

| Parameter | Description | Default | Required |
| - | - | - | -
| `image.repository` | Image to deploy | `cloudzero/cloudwatch-agent` | ✔
| `image.tag` | Image tag to deploy | `cz-cloudwatchagent-0853e59.1`
| `image.pullPolicy` | Pull policy for the image | `IfNotPresent` | ✔
| `clusterName` | Name of your cluster | `cluster_name` | ✔
| `serviceAccount.create` | Whether a new service account should be created | `true` |
| `serviceAccount.name` | Service account to be used | |
| `hostNetwork` | Allow to use the network namespace and network resources of the node | `true` |
| `nodeSelector` | Node labels for pod assignment | {} |
| `tolerations` | Optional deployment tolerations | {} |
| `annotations` | Optional pod annotations | {} |
| `metricsCollectionInterval` | Metrics collection interval in seconds. It can be set to 5, 10, 15, 30, 45, 60 or 120 | 120 |
