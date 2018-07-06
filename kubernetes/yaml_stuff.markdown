# kubernetes yaml stuff

## mounting a subPath (single reference/file) from a configMap
```yaml
          volumeMounts:
            - name: test
              mountPath: /etc/apache2/conf-enabled/test.conf
              subPath: test.conf
      volumes:
        - name: test
          configMap:
            name: test
            - key: test.conf
              path: test.conf
```