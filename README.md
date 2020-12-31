docker build . -t foobarqix:0.1.0
minikube cache add foobarqix:0.1.0
minikube addons enable ingress
helm install --set ingress.host.name=foobarqix.$(minikube ip).nip.io
curl foobarqix.$(minikube ip).nip.io/status
