# FooBarQuix Application

## Overview
*foobarquix* is a simple application for categorizing numbers by given criteria:
- *If the number is divisible by 3 or contains a 3, return a string containing Foo*
- *If the number is divisible by 5 or contains a 5, return a string containing Bar*
- *If the number is divisible by 7 or contains a 7, return a string containing Quix*
- *Else, return the number*

and following constraints:
- *Look at the divisor before the content `(ex: 51 -> FooBar)`*
- *Look at the content in the order it is displayed `(ex: 53 -> BarFoo)`*

User can interact with application via REST API by issuing `GET` requests.

## Quickstart
First run `vagrant up` in project root directory and enter virtualized environment using `vagrant ssh`
Then run following commands to bootstrap local development cluster exposing `foobarquix` application.
```sh
$ cd project
$ make dev-env
```
*Note: this process may take a while on first run. Approximately 25m for machine with 2 cores and 4G of memory*

Once development cluster is up and running you should see summary listing application address:
```
Kubernetes cluster ready

foobarqix available under: http://foobarqix.192.168.49.2.nip.io/
argocd available under: http://argocd.192.168.49.2.nip.io/

You can delete dev-env by issuing: minikube delete
```
*Note: above adresses may be different for your installation.*

Finally, you can interact with application:
1. Check application health:
```sh
$ curl http://foobarquix.192.168.49.2.nip.io/ready
{"status":"ok"}
```
2. Categorize numbers: 
```sh
$ curl http://foobarquix.192.168.49.2.nip.io/53
{"result":"FooBar"}
```

## Project structure
*foobarquix* follows monorepository pattern (i.e. contains application code, infrastructure definition as well as development utilities).
Its structure is as follows:
```
foobarquix
├── Vagrantfile          Virtualized environment definition
├── Makefile             Build, test and deployment targets definitions
├── build                Scripts for orchestrating application development
├── charts               Helm chart for application
│   └── foobarquix
├── images               Container definitions
│   ├── base-env         Base image for development
│   └── runtime          Runtime image for application
├── infra                Deployment related files
│   ├── argocd           ArgoCD configuration
│   └── minikube         Minikube patches
├── postman              Application schema
└── src                  Python project root
    ├── wsgi.py          Application launcher
    ├── app              FastApi application
    │   ├── api          
    │   │   └── routes   Web routes for specific endpoints
    │   ├── core         Aplication configuration
    │   └── models       Request specific logic
    ├── scripts          Helper scripts for linting, formating and testing python code
    └── tests            Test logic
        └── data         Supplementary input data for tests
```

## Development
Provided `Makefile` is a starting point for application and infrastructure development:
```sh
$ make

Usage:
  make <target>
  help             Display this help
  image            Build foobarquix image
  clean-image      Remove foobaquix image
  build            Build foobarquix binary
  test             Test foobarquix app
  clean            Remove .cache directory and foobarquix binary
  dev-env          Start a local Kubernetes cluster using minikube and deploy application
```

## Web Routes
All routes are available on `/` or `/redoc` paths with Swagger or ReDoc.

Additionally, [OpenApi schema](https://github.com/r2r-dev/foobarquix/postman/openapi.json) and [Postman collection](https://github.com/r2r-dev/foobarquix/postman/FooBarQuix.postman_collection.json) are provided.

## License
[MIT](https://github.com/r2r-dev/foobarqix/blob/master/LICENSE)

