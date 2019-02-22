#!bin/bash 

echo "--------------------------------------- S T A R T I N G   O P E R A T I O N  ----------------------------------------"

echo "------------------ Installing EKS-CTL ------------------"

curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin


#------------------ Creating EKS-Cluster ------------------

echo "Enter cluster-name: "
read clustername

echo "Enter region: "
read region

echo "Enter no. of nodes: "
read nodes

echo "Enter node-type: "
read nodetype

echo "Enter exiting aws-key-name: "
read key

eksctl create cluster --name $clustername --nodes=$nodes --ssh-access  --ssh-public-key=$key --region=$region --node-type=$nodetype 

echo "------------------ Ended Cluster Creation ------------------"

echo "."
echo "."
echo "."

echo "------------------ Installing Helm ------------------"

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz
tar -xvf helm-v2.12.3-linux-amd64.tar.gz
mv linux-amd64/ helm-bin/


export PATH=$PATH:/home/ubuntu/helm-bin/
source ~/.bashrc
source etc/environment

rm helm-v2.12.3-linux-amd64.tar.gz

echo "-------------------------------------------------------"

echo "------------------ Initializing Helm ------------------"

helm init 

helm init --upgrade

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"


echo "--------------------------------------- E N D I N G   O P E R A T I O N  ----------------------------------------"
