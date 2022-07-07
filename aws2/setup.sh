cd /Users/mtm/pdev/taylormonacelli/smoketoo/example2
time bash -x setup.sh

cd /Users/mtm/pdev/taylormonacelli/relyleaf
kubectl apply -f aws2

kubectl get configmap tcp-services -n ingress-nginx -o yaml

cat <<'__eot__' >/tmp/ingress-nginx-values.yaml
tcp:
   6379: "default/redis:6379"
__eot__
time helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --values /tmp/ingress-nginx-values.yaml
# time helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --set tcp.6379="default/redis:6379"

cd /Users/mtm/pdev/taylormonacelli/relyleaf/aws2
kubectl patch deployment ingress-nginx-controller --patch "$(cat ingress-nginx-controller-patch.yaml.disabled)" -n ingress-nginx

cd /Users/mtm/pdev/taylormonacelli/relyleaf/aws2 && bash -x main.sh

kubectl get deployment ingress-nginx-controller -n ingress-nginx -o yaml | grep -- --tcp-services-configmap

sleep 60

ssh -T root@taylor-linux-ubuntu-us-east-2.streambox.com<<EOF
systemd-resolve --flush-caches
redis-cli -p 6379 -h redis.mindevent.streambox.com ping
EOF
