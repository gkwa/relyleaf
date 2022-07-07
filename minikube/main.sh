minikube delete
minikube start
kubectl get configmaps --all-namespaces
minikube addons enable ingress --alsologtostderr
kubectl get configmaps --all-namespaces
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-service.yaml
kubectl patch configmap tcp-services -n ingress-nginx --patch '{"data":{"6379":"default/redis-service:6379"}}'
kubectl get configmap tcp-services -n ingress-nginx -o yaml
cat ingress-nginx-controller-patch.yaml
kubectl patch deployment ingress-nginx-controller --patch "$(cat ingress-nginx-controller-patch.yaml)" -n ingress-nginx
telnet $(minikube ip) 6379
