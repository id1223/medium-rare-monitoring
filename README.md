# medium-rare-monitoring

`medium-rare` is a set of scripts and ansible playbooks that allows you to create kubernetes cluster (in minikube)
composed of monitoring, web application and database. Cluster contain multiple HELM deployments orchestrated by Ansible.

## Deployed apps:
- [Wordpress/MariaDB stack](https://bitnami.com/stack/wordpress/helm)
- [Kube-Prometheus stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Prometheus MySql exporter](https://github.com/helm/charts/tree/master/stable/prometheus-mysql-exporter)
- [ElasticSearch, LogStash, Kibana, FileBeat ](https://github.com/elastic/helm-charts)

## Requirements:
These components have to be installed:
- Docker or Docker desktop
- Minikube 
- Ansible
- Helm 

Init script will check all of requirements.

### How to run
There is no need to install anything (as long as you met requirements). 
Once you cloned this repository just run:

`medium-rare_init.sh -h`

Script will show you help message, how to use this script and available options.
```
Syntax: medium-rare_init.sh [-h|c|v|r]
options:
h     Print this Help.
c     Check required packages.
v     Verbose mode.
r     Normal run.
d     Delete stack.
```
If you just want to start a cluster just run  
`medium-rare_monitoring.sh -r`
There is no manual steps required. 

After successful run if you want to reach services just type:
```buildoutcfg
#for Grafana access
kubectl port-forward service/kube-prometheus-grafana -n monitoring 80

#for Kibana access
kubectl port-forward service/kibana-kibana -n monitoring 5601

#If you want you can expose this way every port for ClusterIP service and then reach Prometheus instance etc.
```
Note that default Grafana login and password is:

`user: admin`

`password: prom-operator`

Have fun!

##Configuration
###Values
In `Values` directory you can find separate `<deployment>_values.yaml` file for each deployment. It's standard values
file specific for Helm deployments. For further information/customization please visit [Deployed apps](#Deployed apps)
there are information about every stack.

###Grafana dashboards
All dashboards related to cluster and node monitoring are vanilla dashboards provided by `kube-prometheus-stack`. I made
custom configuration only for Apache and MySql monitoring - it was achieved by creating `configMaps` in `deployments` 
directory.

###ELK&FileBeat configuration
FileBeat is configured as DaemonSet and runs in every POD. Main task for this deployment is to forward logs to Elastic. 
My custom configuration is to scrape also access and error logs from Apache in Wordpress stack. For now logs are uploaded
directly to Elastic, but there is also posibility to upload them to Logstash and make more customization there. Elastic
is only exposing logs to Kibana where you can do your own queries and search for error entries and other interesting facts.
My plan is to add there some datasets.

###Metrics and alerting
This configuration is collecting all of valuable metrics and expose them to Grafana and Elastic. In Grafana for every 
metric you can find a dashboard which visualize them. For now there are implemented only Prometheus vanilla rules from 
kube-prometheus-stack but in future I want to apply also metrics for MySQL and Apache.

###Tests
It was tested on Ubuntu Xenial 16.04 and on MacOS BigSur 11.5.1 with Docker desktop installed.