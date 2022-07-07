/usr/local/bin/minikube-darwin-amd64 delete
/usr/local/bin/minikube-darwin-amd64 start
kubectl get configmaps --all-namespaces
/usr/local/bin/minikube-darwin-amd64 addons enable ingress
kubectl get configmaps --all-namespaces
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-service.yaml
kubectl patch configmap tcp-services -n ingress-nginx --patch '{"data":{"6379":"default/redis-service:6379"}}'
kubectl get configmap tcp-services -n ingress-nginx -o yaml
cat ingress-nginx-controller-patch.yaml
kubectl patch deployment ingress-nginx-controller --patch "$(cat ingress-nginx-controller-patch.yaml)" -n ingress-nginx
telnet $(/usr/local/bin/minikube-darwin-amd64 ip) 6379
