Now that we saw the ease of deployment of an application into a knative runtime,  let us look at another important feature,  the route distribution across multiple revisions and using it for a ***blue-green*** deployment model. 

To be able to discuss this,  we need to understand a couple more key pieces of knative. 

Let us look at the picture for the knative-serving flow again.. 

Click to see the current available revisions

kubectl apply -f workshop/content/files/blue-service.yml 
configuration.serving.knative.dev/blue-green-demo created


```terminal:execute
command: rev01=$(kubectl get configurations blue-green-demo -o=jsonpath='{.status.latestCreatedRevisionName}') &&  sed -i "s/blue/$rev01/g" workshop/content/files/blue-only-routes.yml
```

```terminal:execute
command: kubectl get revisions 
```

```terminal:execute
command: kubectl get routes   
```

```terminal:execute
command: k get configurations.serving.knative.dev helloworld-go -o yaml
```

I would call out a couple of key info in the yaml ( result of the above command), 
- The revisions `latestCreatedRevisionName: helloworld-go-00001` and `latestReadyRevisionName: helloworld-go-00001`
- The ENV variable named `TARGET`

```yaml
apiVersion: serving.knative.dev/v1
kind: Configuration
metadata:
  annotations:
    serving.knative.dev/creator: system:serviceaccount:cnr-fundamentals-w01:cnr-fundamentals-w01-s002
    serving.knative.dev/lastModifier: system:serviceaccount:cnr-fundamentals-w01:cnr-fundamentals-w01-s002
    serving.knative.dev/routes: helloworld-go
  creationTimestamp: "2021-05-04T19:03:44Z"
  generation: 1
  labels:
    serving.knative.dev/service: helloworld-go
    serving.knative.dev/serviceUID: a25a0374-e722-4d71-aafc-5f9dad2bf932
  managedFields:
  - apiVersion: serving.knative.dev/v1
    fieldsType: FieldsV1
  name: helloworld-go
  namespace: cnr-fundamentals-w01-s002
  ownerReferences:
  - apiVersion: serving.knative.dev/v1
    blockOwnerDeletion: true
    controller: true
    kind: Service
    name: helloworld-go
    uid: a25a0374-e722-4d71-aafc-5f9dad2bf932
  resourceVersion: "3144384"
  selfLink: /apis/serving.knative.dev/v1/namespaces/cnr-fundamentals-w01-s002/configurations/helloworld-go
  uid: 33ca72d2-ef65-4c5e-97d9-8e4f995866b4
spec:
  template:
    metadata:
      annotations:
        client.knative.dev/user-image: gcr.io/knative-samples/helloworld-go
      creationTimestamp: null
    spec:
      containerConcurrency: 0
      containers:
      - env:
        - name: TARGET
          value: Go Sample v1
        image: gcr.io/knative-samples/helloworld-go
        name: user-container
        readinessProbe:
          successThreshold: 1
          tcpSocket:
            port: 0
        resources: {}
      enableServiceLinks: false
      timeoutSeconds: 300
status:
  conditions:
  - lastTransitionTime: "2021-05-04T19:03:49Z"
    status: "True"
    type: Ready
  latestCreatedRevisionName: helloworld-go-00001
  latestReadyRevisionName: helloworld-go-00001
  observedGeneration: 1
```




kn service create demo --image gcr.io/knative-samples/helloworld-go --env TARGET=blue
    2  kn service update demo --tag $(kn revision list -o 'jsonpath={.items[0].metadata.name}')=blue
    3  kn service update demo --env TARGET=green
    4  kn service update demo --traffic blue=50,@latest=50
    5  for ((i=1;i<=100;i++)); do   curl -v --header "Connection: keep-alive" "localhost:8080/user?uuid=52010&model_id=20&attr=0"; done
    6  for ((i=1;i<=100;i++)); do   curl -v --header "Connection: keep-alive" "http://demo.clue2solve-w01-s003.knative.g.demome.cloud/"; done
    7  for ((i=1;i<=100;i++)); do   curl --header "Connection: keep-alive" "http://demo.clue2solve-w01-s003.knative.g.demome.cloud/"; done
    8  history 

    1  kn service create bg-demo --image ghcr.io/clue2solve/knative-colors/colors:start  --env HELLO_BG_COLOR="RED"
    2  kn service update  bg-demo --image ghcr.io/clue2solve/knative-colors/colors:start  --env HELLO_BG_COLOR="blue"
    3  kn revisions list
    6   kn service update bg-demo --traffic bg-demo-00002=50,bg-demo-00001=50