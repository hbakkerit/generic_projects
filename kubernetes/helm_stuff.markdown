# specific context (cluster):
use a specific kube context, recognised by kubectl and found using ```kubectl config view```
## syntax
```helm --kube-context <cluster>```
## example
```helm install --kube-context <cluster>```

# install stuff w/ helm
The install argument must be a chart reference, a path to a packaged chart, a path to an unpacked chart directory or a URL.

To override values in a chart, use either the ‘–values’ flag and pass in a file or use the ‘–set’ flag and pass configuration from the command line, to force a string value use ‘–set-string’.

## with value files
you can specify the ‘–values’/‘-f’ flag multiple times. The priority will be given to the last (right-most) file specified. The --dry-run and --debug flags are used to generate the yaml files but not install them:
```helm install -f <values.yaml> -f <override.yaml> --dry-run --debug ./chart```


# inspecting charts and values
## helm lint
examines a chart for possible issues
### syntax
```helm lint [flags] PATH```

## helm inspect
inspect a chart
### syntax
```helm inspect [CHART]```



## helm rollback
This command rolls back a release to a previous revision.
### syntax
 helm rollback [flags] [RELEASE] [REVISION]