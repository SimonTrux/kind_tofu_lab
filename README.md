# kind tofu lab project

## Setup

### Prerequisites 

- podman
- Go
- kind gitbub
- tofu

### Running the kubernetes cluster 

To run the cluster
```bash
# To start it
kind create cluster --config ./cluster/01_1c2w.yml # --name c1 # if not in config file
# To delete it
kind delete clusters cluster1
```
## Adding services

### All at once

To start all services at once :

```bash
kubectl apply -R -f ./services
```

### Dashbord

```bash
# to install the dashbord pods :
https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

# expose dashbord locally to localhost:8001
kubectl proxy --address=0.0.0.0

# You can now go to the dashboard at http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/ 


# Create dashbord user, from
# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

kubectl apply -f ./services/dashboard/11_create_service_account.yml
kubectl apply -f ./services/dashboard/12_create_clusterRoleBinding.yml


# Create a token for the service account "admin-user"
kubectl -n kubernetes-dashboard create token admin-user

# or for a persistent token
kubectl apply -f ./services/dashboard/13_create_persistent_token.yml
# and to retrieve it
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d

```

### Nginx

To deploy nginx quiclky :
```bash
kubectl create deployment nginx-project --image=nginx
# then edit it if needed
kubectl edit deployment nginx-project
# and more
kubectl describe ...
kubectl logs ...
```

Otherwise, do 

```bash
kubectl apply -f services/nginx/01_nginx.yml

Then apply Ingress

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

```


