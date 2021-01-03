# foobarquix

A Helm chart for FooBarQuix

**Homepage:** <https://github.com/r2r-dev/foobarquix>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Artur Stachecki | dev@r2r.sh |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.host | string | `"0.0.0.0"` | Host from which application accepts connections |
| app.port | int | `8000` | Port on which application listens for connections |
| app.workers | int | `4` | Number of workers to run in container |
| fullnameOverride | string | `""` | Application name override |
| image.digest | string | `"sha256:e4154f33e5210137c8dbc593afa357cc1cb969967d6ea3431a32ff9565a4e586"` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"foobarquix"` |  |
| image.tag | string | `"0.1.0"` |  |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host.name | string | `"foobarquix.kubernetes.local"` |  |
| ingress.host.paths[0] | string | `"/"` |  |
| nameOverride | string | `""` | Application name override |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `3` | Number of replicas to deploy |
| resources | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` | Service type to use |
| tolerations | list | `[]` |  |

