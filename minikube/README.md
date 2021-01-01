```
kubectl patch deployment ingress-nginx-controller --type='json' --patch "$(cat ingress-nginx-controller.patch.json)" -n kube-system
```
