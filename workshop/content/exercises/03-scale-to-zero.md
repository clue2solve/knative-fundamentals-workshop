In the Previous module ,  we ran the test of the app. Lets quickly run the same again. 
```terminal:execute
command: URL=$(kn service list  helloworld-go -o json  | jq --raw-output '.items[].status.url') \
        echo $URL \
        curl $URL 
```

Lets watch the pods on the second terminal. 
```terminal:execute
command: watch kubectl get pods
```

Now, lets runs some small load on the service using Apache bench and watch the pods.
```terminal:execute
command: ab -n 1000 -c 100 $URL
session: 1
```
