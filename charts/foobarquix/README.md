# foobarquix

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

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
| app.host | string | `"0.0.0.0"` |  |
| app.port | int | `8000` |  |
| app.workers | int | `4` |  |
| fullnameOverride | string | `""` |  |
| image.digest | string | `"sha256:e4154f33e5210137c8dbc593afa357cc1cb969967d6ea3431a32ff9565a4e586"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"foobarquix"` |  |
| image.tag | string | `"0.1.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host.name | string | `"foobarquix.kubernetes.local"` |  |
| ingress.host.paths[0] | string | `"/"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `3` |  |
| resources | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| tolerations | list | `[]` |  |

