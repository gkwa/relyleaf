#!/bin/bash

domain_zone_id=ZYM2WVE2N8MU5
elb_zone_id=Z35SXDOTRQ7X7K
export LB=$(kubectl get svc --namespace ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')
echo $LB
cat <<__eot__ >/tmp/redis.json
{
  "Comment": "Deleting Alias resource record sets in Route 53",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "redis.mindevent.streambox.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "$elb_zone_id",
          "DNSName": "$LB",
          "EvaluateTargetHealth": true
        }
      }
    }
  ]
}
__eot__
cat /tmp/redis.json
PAGER=cat aws route53 change-resource-record-sets --region us-east-1 --hosted-zone-id $domain_zone_id --change-batch file:///tmp/redis.json


kubectl delete configmap/tcp-services --namespace ingress-nginx --wait
kubectl delete deployment/redis-deployment --namespace default --wait
kubectl delete service/redis --namespace default --wait

cd /Users/mtm/pdev/taylormonacelli/smoketoo/example2
bash -x teardown.sh

kubectl delete namespace prometheus --wait
