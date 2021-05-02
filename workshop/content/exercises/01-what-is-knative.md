***Knative*** brings "serverless" experience to kubernetes. It also tries to codify common patterns and best practices for running applications while hiding away the complexity of doing that on kubernetes. It does so by providing two sets of components:

Serving - Request-driven compute that can scale to zero
Eventing - Management and delivery of events

In this Workshop,  we will focus primarily on the knative-serving aspects

At a high level ***knative-serving*** is an abstraction over the bare k8s **deployment->pod->service->ingress** model. knative allows you to ask for a ***knative-service*** with an image at the core. You will be able to provide many configurations that will/can override all the amazing opinionated defaults provided by the abstraction. 

One of the key highlights of the knative-serving functionality is its scale-to-zero function where the application instances will be reduced to zero if there is no activity around on the app for a predefined amount of time. This is one of the core tenets the serverless paradigm. We will sure witness this key function on this fundamentals workshop today. 
