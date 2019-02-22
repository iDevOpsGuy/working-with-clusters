#!bin/bash 

echo "--------------------------------------- S T A R T I N G   O P E R A T I O N  ----------------------------------------"

sh eks-hel-config.sh 

echo "------------------ Creating EKS-Cluster ------------------"

helm install --name grafana stable/grafana


echo "------------------ Pulling out user-password ------------------"

kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


echo "------------------ Pulling out URL ------------------"

export POD_NAME=$(kubectl get pods --namespace default -l "app=grafana,component=" -o jsonpath="{.items[0].metadata.name}") 
kubectl --namespace default port-forward $POD_NAME 3000

export POD_NAME=$(kubectl get pods --namespace default -l "app=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 3000


echo "--------------------------------------- E N D I N G   O P E R A T I O N  ----------------------------------------"
