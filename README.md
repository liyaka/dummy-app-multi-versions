# dummy-app-multi-versions

## Deploy multiple version dynamically with nginx ingress controller and Helm

Very simple python Flask application that has 2 deployment environments:

- **dev** - deploy only one version that always overwrites the already installed one
- **prod** - manage multiple versions

## Set your configuration
Set values in `helm-chart/dummy-app/values-dev.yaml` and `helm-chart/dummy-app/values-prod.yaml`:

- DEV-REGISTRY/PROD-REGISTRY - your registries urls
- DEV-CLUSTER-DNS-NAME/PROD-CLUSTER-DNS-NAME - your clusters DNS names

## Build
Set environment variables:

- `BUILD_NUMBER`, the default is 1
- `REGISTRY_URL`, the default is empty
Run build.sh to build and push docker images
(Make sure you are logged in to your registry)

```
export BUILD_NUMBER=4
export REGISTRY_URL=myreg/
./build.sh
```

## Deployment

### Install nginx controller

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --set rbac.create=true --set controller.service.loadBalancerIP="<your external IP>" --set controller.service.ports.http="<your port>"
```

### Deploy to dev

Replace `VERSION_NAME` in `helm-chart/dummy-app/values-dev.yaml` with your full version name (like `1.0.4`)
Run:
```
cd helm-chart
helm upgrade --install --cleanup-on-fail  -f dummy-app/values-dev.yaml dummy-app ./dummy-app
```

Call your service:
```
http://<dev cluster DNS name>:5000
```
like
```
http://mydevserver:5000
```

### Deploy to prod
Replace `VERSION_NAME` in `helm-chart/dummy-app/values-prod.yaml` with your full version name (like 1.0.4)
Run:
```
cd helm-chart
helm upgrade --install --cleanup-on-fail  -f dummy-app/values-dev.yaml dummy-app-<version> ./dummy-app
```
like
```
cd helm-chart
helm upgrade --install --cleanup-on-fail  -f dummy-app/values-dev.yaml dummy-app-1.0.4 ./dummy-app
```

Call your service:
```
http://<dev cluster DNS name>:5000/v<version>
```
like:
```
http://myprodserver:5000/v1.0.4
```
