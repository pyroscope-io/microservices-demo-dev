


## Google-microservice with pyroscope
To use Google-microservice with pyroscope we need to do few steps mentioned below 

### Retagging Docker Images
Docker images need to build and pushed to repositories. (**Note: Even without Retagging the docker Image you can still run Using docker images by beellzrocks**)\
Dockerfile of each microservice is stored inside their respective folder under the src folder. 

Follow these steps:

Example for Email service
go to [src/emailservice](./src/emailservice/Dockerfile)


- Build image
```console
docker build . -t <yourRepository/emailservice:version>
```
- Push image

```console
docker push <yourRepository/emailservice:version>
```

**Note: For each microservice image that we retag we need to change its image reference in the respective manifest**

For the Email service we can find the yaml file inside:
kubernetes-manifests/emailservice.yaml

[emailservice.yaml](kubernetes-manifests/emailservice.yaml)
```
   containers:
      - name: server
        image: beellzrocks/emailservice  #Change the image with your repository tag
```        

## Steps to install microservices and profile them using pyroscope

To install the pyroscope we are going to use the helm chart.\
[Helm](https://helm.sh) must be installed to use the chart. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

 Get the Repo of Pyrscope
```console
helm repo add pyroscope-io https://pyroscope-io.github.io/helm-chart
```

Install the chart:

```console
helm install pyroscope pyroscope-io/pyroscope 
```
Install microservices 
```console
kubectl apply -f kubernetes-manifests/
```
To view all the pods:
```console
kubectl get pods
```
To view Pyroscope UI
```console 
kubectl port-forward svc/pyroscope 8080:4040
```
Now you can access pyroscope UI on http://localhost:8080

## Changes we did to integrate microservices with pyroscope

**Python**

Need to change in [Dockerfile](./src/emailservice/Dockerfile):
```console
COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
CMD [ "pyroscope", "exec", "python", "email_server.py ]
```


for changes in kubernetes manifest file 
ref: [Emailservice](./kubernetes-manifests/emailservice.yaml)


**.Net**

Need to change in [Dockerfile](./src/cartservice/src/Dockerfile):
```
COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
ENTRYPOINT ["pyroscope", "exec", "-spy-name", "dotnetspy", "/app/cartservice"]
```
for changes in kubernetes manifest file 
ref: [Cartservice](./kubernetes-manifests/cartservice.yaml)

**Go**

Changes to be done in [main.go](./src/frontend/main.go)

```
import (
  pyroscope "github.com/pyroscope-io/pyroscope/pkg/agent/profiler"
)

func main() {

  pyroscope.Start(pyroscope.Config{
    ApplicationName: os.Getenv("APPLICATION_NAME"),
    ServerAddress:   os.Getenv("SERVER_ADDRESS"),
  })
  / code here
) 
```
for changes in kubernetes manifest file 
ref:  [Frontend](./kubernetes-manifests/frontend.yaml)


## Microservices we will be profiling using pyroscope

Python:
* Recommendationservice 
* Emailservice

Go:
* Frontend
* Productcatalogservice
* Shippingservice
* Checkoutservice

.Net: 
* Cartservice