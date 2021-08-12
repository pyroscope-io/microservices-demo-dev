The project is a fork of **Online Boutique** cloud-native [microservices demo](https://github.com/GoogleCloudPlatform/microservices-demo)
application by Google with support for pyroscope profiling.

## Install microservices and profile them using pyroscope

To install the microservices demo and pyroscope we are going to use helm charts.\
[Helm](https://helm.sh) must be installed to use the chart. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Add Pyroscope helm charts repo:
```console
helm repo add pyroscope-io https://pyroscope-io.github.io/helm-chart
```

Install the chart:
```console
helm install pyroscope pyroscope-io/pyroscope 
```

Install microservices:
```console
helm install microservices-demo ./charts/microservices-demo
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

### Microservices we will be profiling using pyroscope

**Python**
* `recommendationservice`
* `emailservice`

Need to change in [Dockerfile](./src/emailservice/Dockerfile):
```console
COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
CMD [ "pyroscope", "exec", "python", "email_server.py ]
```

**Go**
* `frontend`
* `productcatalogservice`
* `shippingservice`
* `checkoutservice`

Changes to be done in [main.go](./src/frontend/main.go)

```
import (
    pyroscope "github.com/pyroscope-io/pyroscope/pkg/agent/profiler"
)

func main() {
    pyroscope.Start(pyroscope.Config{
        ApplicationName: os.Getenv("PYROSCOPE_APPLICATION_NAME"),
        ServerAddress:   os.Getenv("PYROSCOPE_SERVER_ADDRESS"),
    })

    // code here
) 
```

**.NET**
* `cartservice`

Need to change in [Dockerfile](./src/cartservice/src/Dockerfile):
```
COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope
ENTRYPOINT ["pyroscope", "exec", "-spy-name", "dotnetspy", "/app/cartservice"]
```

### Docker Images

Docker images need to be build and pushed to repositories before deployment.

```
make all
```

Supported variables:

- `REGISTRY` specifies registry for images built.
- `TAG` specifies tag to use (defaults to `0.1.0`).
- `PYROSCOPE_VERSION` overrides default version (`0.0.37`) of pyroscope image.
- `PYROSCOPE_IMAGE` overrides pyroscope image used.
