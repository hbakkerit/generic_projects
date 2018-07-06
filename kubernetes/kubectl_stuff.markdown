# KubeCTL stuff
## importing and exporting a configMap
### exporting to file
#### syntax
```kubectl get configmap <configmap_name> -o yaml --namespace=<namespace> > destination_file.yaml```

### importing from file
#### syntax
```kubectl create configmap <configmap_name> --from-file=path/to/bar```

## switching context
```kubectl config use-context <context>```
