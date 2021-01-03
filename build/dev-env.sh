#!/usr/bin/env bash

if [ -n "$DEBUG" ]; then
	set -x
fi

set -o errexit
set -o nounset
set -o pipefail

DIR=$(cd $(dirname "${BASH_SOURCE}") && pwd -P)

if ! command -v minikube &> /dev/null; then
  echo "minikube is not installed"
  exit 1
fi

if ! command -v kubectl &> /dev/null; then
  echo "kubectl is not installed"
  exit 1
fi

if ! command -v helm &> /dev/null; then
  echo "helm is not installed"
  exit 1
fi

HELM_VERSION=$(helm version 2>&1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+') || true
if [[ ${HELM_VERSION} < "v3.0.0" ]]; then
  echo "Please upgrade helm to v3.0.0 or higher"
  exit 1
fi

KUBE_CLIENT_VERSION=$(kubectl version --client --short | awk '{print $3}' | cut -d. -f2) || true
if [[ ${KUBE_CLIENT_VERSION} -lt 16 ]]; then
  echo "Please update kubectl to 1.16 or higher"
  exit 1
fi

echo "[dev-env] starting minikube"
MINIKUBE_IN_STYLE=0 minikube start --driver=docker 2>/dev/null

echo "[dev-env] enabling ingress addon"
minikube addons enable ingress

echo "[dev-env] enabling ssl-passthrough for ingress controller"
kubectl patch deployment ingress-nginx-controller --type='json' --patch "$(cat infra/minikube/ingress-nginx-controller.patch.json)" -n kube-system
# Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/ingress-nginx-controller -n kube-system"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 10
done

INGRESS_HOST="$(minikube ip).nip.io"

echo "[dev-env] deploying argocd"
helm repo add argo \
    https://argoproj.github.io/argo-helm

helm upgrade --install \
    argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --version 2.8.0 \
    --set server.ingress.enabled=true \
    --set server.ingress.https=true \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io\/force-ssl-redirect"=true \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io\/ssl-passthrough"=true \
    --set server.ingress.hosts="{argocd.$INGRESS_HOST}" \
    --wait

export PASS="$(kubectl --namespace argocd \
    get pods \
    --selector app.kubernetes.io/name=argocd-server \
    --output name \
    | cut -d'/' -f 2)"

argocd login \
    --insecure \
    --username admin \
    --password "$PASS" \
    --grpc-web \
    "argocd.${INGRESS_HOST}"

echo "[dev-env] pushing app image"
#minikube cache delete "foobarquix:${TAG}" 2> /dev/null || true
minikube cache add "foobarquix:${TAG}"
minikube cache reload

echo "[dev-env] deploying foobarquix"
kubectl apply -f infra/argocd -n argocd
argocd app set foobarquix -p ingress.host.name="foobarquix.${INGRESS_HOST}"

ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl get namespace foobarquix -n foobarquix"
until $ROLLOUT_STATUS_CMD 2>/dev/null || [ $ATTEMPTS -eq 60 ]; do
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 10
done

ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/foobarquix -n foobarquix"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 10
done

cat <<EOF

Kubernetes cluster ready

foobarquix available under: http://foobarquix.${INGRESS_HOST}/
argocd available under: http://argocd.${INGRESS_HOST}/

You can delete dev-env by issuing: minikube delete
EOF

