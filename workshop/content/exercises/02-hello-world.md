Let us use a very basic barebone helloworld app as an example to deploy into the knative runtime. 

We will use the helloworld-go sample app on the knative sources. 
```go
package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
  log.Print("helloworld: received a request")
  target := os.Getenv("TARGET")
  if target == "" {
    target = "World"
  }
  fmt.Fprintf(w, "Hello %s!\n", target)
}

func main() {
  log.Print("helloworld: starting server...")

  http.HandleFunc("/", handler)

  port := os.Getenv("PORT")
  if port == "" {
    port = "8080"
  }

  log.Printf("helloworld: listening on port %s", port)
  log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
```
This app has been compiled into a simple image that is available at 
`gcr.io/knative-samples/helloworld-go`

Our cluster has the a recent version of knative serving installed. Let us walk through the steps you will need to do if you have to install the same application on the bare-bone k8s dial-tone. Lets build a yaml file that creates a deployment, service and an ingress for the app. 

```yaml
to be added 
```

Now let us run a quick test on the app. 

Great it works. But think about all the details that you as a developer need to know to accomplish that. 

Now lets try the same using the Knative way !
```terminal:execute
command: kn service create helloworld-go --image gcr.io/knative-samples/helloworld-go --env TARGET="Go Sample v1"
```

Time to test it 
```terminal:execute
command: curl $(kn service list  helloworld-go -o json  | jq --raw-output '.items[].status.url')
```

There we go, we deployed our app on the knative runtime and tested the URL. That was simple enough. 


