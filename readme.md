# About
A sample application that is based on Laravel, MySQL, Redis, Nginx, Kubernetes.

# Prepare

1. install Docker for Mac/Windows Edge version and enable kubernetes

https://docs.docker.com/docker-for-mac/install/

2. install kubectl

https://kubernetes.io/docs/tasks/tools/install-kubectl/

3. install helm

https://github.com/kubernetes/helm

4. install nginx-controller

```sh
$ helm init
$ helm install --name my-release stable/nginx-ingress

```

5. install skaffold

https://github.com/GoogleContainerTools/skaffold

# Build

```sh
$ git clone git@github.com:ryosukes/laravel-k8s-sample.git
$ cd laravel-k8s-sample
$ kubectl apply -f kubernetes/db

# set common name 'sample-laravel.localhost'
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/nginx-selfsigned.key -out /tmp/nginx-selfsigned.crt; openssl dhparam -out /tmp/sample.pem 2048
$ kubectl create secret tls tls-certificate --key /tmp/nginx-selfsigned.key --cert /tmp/nginx-selfsigned.crt

$ skaffold run
```

You can access to https://sample-laravel.localhost
