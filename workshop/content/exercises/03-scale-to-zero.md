In the Previous module ,  we ran the test of the app. Lets quickly run the same again. 

```terminal:execute
command: URL=$(kn service list  helloworld-go -o json  | jq --raw-output '.items[].status.url') && echo $URL && curl $URL 
```

Lets watch the pods on the second terminal. 
```terminal:execute
command: watch kubectl get pods
session: 2
```

Now, lets runs some small load on the service using Apache bench and watch the pods.
```terminal:execute
command: URL=$(kn service list  helloworld-go -o json  | jq --raw-output '.items[].status.url') && echo $URL && ab -n 1500 -c 100 $URL
```
Watch the pods go down after the load goes to zero. After about a minute,  you will see the pods terminating. Once the termination starts, lets re-run our benchmark command and observe that the pods are started  (based on the new need).

```terminal:execute
command: URL=$(kn service list  helloworld-go -o json  | jq --raw-output '.items[].status.url') && echo $URL && ab -n 1500 -c 100 $URL
```
