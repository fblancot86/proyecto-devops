# Deploying Flask app in Kubernetes

Checking that all manifests have been deployed in Kubernetes and they are running properly.

```bash
kubectl get all -n flask-api
NAME                                       READY   STATUS    RESTARTS   AGE
pod/flaskapp-deployment-66d97c5779-pjhw7   1/1     Running   0          16h
pod/mysql-9b67db966-62vh8                  1/1     Running   0          15h

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/flask-nodeport   NodePort    10.43.234.106   <none>        5000:32001/TCP   17h
service/mysql            ClusterIP   None            <none>        3306/TCP         17h

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/flaskapp-deployment   1/1     1            1           17h
deployment.apps/mysql                 1/1     1            1           17h

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/flaskapp-deployment-66d97c5779   1         1         1       16h
replicaset.apps/flaskapp-deployment-d68975d74    0         0         0       17h
replicaset.apps/mysql-9b67db966                  1         1         1       17h

NAME                                           REFERENCE                        TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/flask-ha   Deployment/flaskapp-deployment   2%/80%    1         10        1          17h
```
