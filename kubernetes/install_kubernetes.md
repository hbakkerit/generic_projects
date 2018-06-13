#using_minikube

Download the latest release from the Minikube release page. Once downloaded, we need to make it executable and copy it in the PATH:
``` curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/ ```

We can start Minikube with the minikube start command:

```minikube start```

Check the minikube status with the minikube status command:

```minikube status```

Stop minikube with the minikube stop command:

```minikube stop```