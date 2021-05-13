Knative Eventing requires one infrastructure prerequisite beyond the Kubernetes cluster and the Cloud Native Runtimes for Tanzu - a message broker. You can use RabbitMQ or an in-memory broker. In a real world environment, an operator would provision a reliable RabbitMQ instance for you, but in this workshop, we'll deploy our own in-memory broker. Run the following in the terminal.
```terminal:execute
command: kubectl create -f /opt/workshop/setup/eventing-broker.yaml -n ${SESSION_NAMESPACE}
```

In order to see that the event flow is working, we need an event consumer. This consumer is a Knative sample application that simply writes out a text representation of the messages it receives to stdout. Deploy the consumer by running the following in the terminal.
```terminal:execute
command: kubectl create -f /opt/workshop/setup/eventing-consumer.yaml -n ${SESSION_NAMESPACE}
```

We also need an event producer to push events into the system. The below command will deploy a Knative sample event producer that sends a simple text message once per minute. Deploy it by running the following in the terminal.
```terminal:execute
command: ytt --data-value sessionns=${SESSION_NAMESPACE} -f /opt/workshop/setup/eventing-producer.yaml -f /opt/workshop/setup/values.yaml | kubectl create -f-
```

The final component that we need to create is an Eventing trigger. The trigger acts as a subscription to events from a specific Eventing broker. In this case, we'll subscribe our consumer to events on the broker we created with the first command. Create the trigger by running the following in the terminal.
```terminal:execute
command: ytt --data-value sessionns=${SESSION_NAMESPACE} -f /opt/workshop/setup/eventing-trigger.yaml -f /opt/workshop/setup/values.yaml | kubectl create -f-
```

Now we should be able to view events from our producer in the output log of our consumer. View the logs by running the following command in the terminal.
```terminal:execute
command: kubectl logs -l serving.knative.dev/service=event-display -c user-container -n ${SESSION_NAMESPACE} --since=10m --tail=50
```
Note: the producer only emits one message per minute, so you may not see any output immediately from the above command. Run it a few times over the course of the next few minutes and you should see a new event once per minute.
