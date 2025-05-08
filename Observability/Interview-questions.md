# Monitoring & Logging Interview Questions

## Table of Contents
- [Prometheus, Grafana, ELK, and Observability](#prometheus-grafana-elk-and-observability)
- [Log Shipping / Forwarding / Alerts](#log-shipping--forwarding--alerts)
- [Linux/Cloud System Monitoring](#linuxcloud-system-monitoring)

## Prometheus, Grafana, ELK, and Observability

### How do you monitor the cluster through Prometheus?
Prometheus monitors Kubernetes clusters by:
1. Deploying Prometheus server in the cluster
2. Using ServiceMonitor or PodMonitor CRDs to discover targets
3. Scraping metrics from kube-state-metrics and node-exporter
4. Collecting metrics from various Kubernetes components (API server, kubelet, etc.)
5. Storing time-series data for analysis and alerting

### Explain installation of Prometheus and Grafana
1. **Prometheus Installation**:
   ```bash
   # Using Helm
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm install prometheus prometheus-community/kube-prometheus-stack
   ```

2. **Grafana Installation**:
   ```bash
   # Using Helm
   helm repo add grafana https://grafana.github.io/helm-charts
   helm install grafana grafana/grafana
   ```

### How does Prometheus collect metrics?
Prometheus collects metrics through:
1. Pull-based scraping of HTTP endpoints
2. Service discovery mechanisms
3. Pushgateway for short-lived jobs
4. Exporters for third-party systems
5. Recording rules for pre-computed metrics

### How is Prometheus set up?
1. Deploy Prometheus server
2. Configure service discovery
3. Set up alerting rules
4. Configure storage
5. Set up authentication and authorization

### How is Grafana set up?
1. Deploy Grafana server
2. Configure data sources (Prometheus, etc.)
3. Set up authentication
4. Create dashboards
5. Configure alerts

### How do you configure a Grafana dashboard?
1. Add data sources
2. Create new dashboard
3. Add panels
4. Configure queries
5. Set up variables
6. Configure alerts
7. Share dashboard

### What are data sources for Grafana and Kibana?
**Grafana Data Sources**:
- Prometheus
- Elasticsearch
- InfluxDB
- Graphite
- CloudWatch
- Azure Monitor

**Kibana Data Sources**:
- Elasticsearch
- Logstash
- Beats

### What is Kibana?
Kibana is a visualization and management tool for Elasticsearch that provides:
1. Log analysis
2. Data visualization
3. Dashboard creation
4. Machine learning capabilities
5. Security features

### What are indices and index in Kibana?
- **Indices**: Collections of documents in Elasticsearch
- **Index**: A single collection of documents
- Used for:
  1. Data organization
  2. Performance optimization
  3. Data lifecycle management
  4. Access control

### How does ELK setup work and what type of agents have you collected?
**ELK Stack Components**:
1. **Elasticsearch**: Data storage and search
2. **Logstash**: Log processing
3. **Kibana**: Visualization
4. **Beats**: Lightweight data shippers

**Common Agents**:
- Filebeat
- Metricbeat
- Packetbeat
- Heartbeat
- Auditbeat

### What is observability architecture?
Observability architecture includes:
1. **Three Pillars**:
   - Metrics
   - Logs
   - Traces
2. **Components**:
   - Data collection
   - Storage
   - Analysis
   - Visualization
   - Alerting

### What is the difference between observability and monitoring?
**Monitoring**:
- Proactive tracking of known issues
- Pre-defined metrics
- Reactive approach

**Observability**:
- Understanding system behavior
- Unknown unknowns
- Proactive approach
- Deeper insights

### When we have logs, why do we need trace?
Traces provide:
1. Request flow visualization
2. Latency analysis
3. Dependency mapping
4. Performance bottlenecks
5. Distributed transaction tracking

### Explain metrics, logs, and trace including all used tools
**Metrics**:
- Prometheus
- Grafana
- CloudWatch
- Datadog

**Logs**:
- ELK Stack
- Fluentd
- CloudWatch Logs
- Splunk

**Traces**:
- Jaeger
- Zipkin
- OpenTelemetry
- AWS X-Ray

### How does observability help in maintaining site reliability?
1. Early problem detection
2. Performance optimization
3. Capacity planning
4. Incident response
5. User experience monitoring

### How do you receive alerts in your project and how is it set up?
1. **Alert Sources**:
   - Prometheus AlertManager
   - Grafana Alerts
   - CloudWatch Alarms
2. **Notification Channels**:
   - Email
   - Slack
   - PagerDuty
   - SMS

## Log Shipping / Forwarding / Alerts

### How do you send log files from EC2 to S3?
1. **Using AWS CLI**:
   ```bash
   aws s3 cp /path/to/logs s3://bucket-name/logs/
   ```
2. **Using CloudWatch Agent**:
   - Install agent
   - Configure log groups
   - Set up IAM roles
3. **Using Fluentd/Fluent Bit**:
   - Configure S3 output plugin
   - Set up buffering
   - Configure IAM roles

### How do you automate log checking, CPU metrics, and CloudWatch alerts?
1. **Using AWS CLI and CloudWatch**:
   ```bash
   # Check CPU metrics
   aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization

   # Set up alarm
   aws cloudwatch put-metric-alarm --alarm-name CPUAlarm --alarm-description "CPU Usage Alert" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=i-1234567890abcdef0 --evaluation-periods 2 --alarm-actions arn:aws:sns:region:account-id:topic-name
   ```

### How do you troubleshoot incomplete logs across AKS, Ingress, App, and Infra?
1. **Check Log Sources**:
   - Container logs
   - Ingress controller logs
   - Application logs
   - Infrastructure logs
2. **Verify Log Collection**:
   - Agent configuration
   - Network connectivity
   - Storage capacity
3. **Analyze Log Patterns**:
   - Time gaps
   - Error patterns
   - Resource constraints

### How do you track a particular IP in S3 logs?
1. **Using AWS CLI**:
   ```bash
   aws s3 cp s3://bucket-name/logs/ logfile.txt
   grep "IP_ADDRESS" logfile.txt
   ```
2. **Using Athena**:
   ```sql
   SELECT * FROM logs WHERE client_ip = 'IP_ADDRESS'
   ```

### How do you filter a particular IP from AWS CloudWatch Log Group?
1. **Using CloudWatch Logs Insights**:
   ```
   fields @timestamp, @message
   | filter client_ip = 'IP_ADDRESS'
   | sort @timestamp desc
   ```

## Linux/Cloud System Monitoring

### How do you monitor CPU metrics in Grafana?
1. **Set up Prometheus Node Exporter**
2. **Configure Grafana Dashboard**:
   - CPU utilization
   - Load average
   - Context switches
   - Interrupts

### How do you monitor Azure VM memory and alert if it crosses 80%?
1. **Using Azure Monitor**:
   ```bash
   # Set up metric alert
   az monitor metrics alert create \
     --name "MemoryAlert" \
     --resource-group "myResourceGroup" \
     --scopes "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Compute/virtualMachines/{vm-name}" \
     --condition "avg Percentage Memory Used > 80" \
     --description "Alert when memory usage exceeds 80%"
   ```

### How do you handle disk, CPU alerts?
1. **Disk Alerts**:
   - Monitor disk usage
   - Set up cleanup jobs
   - Configure auto-scaling
2. **CPU Alerts**:
   - Monitor CPU utilization
   - Set up auto-scaling
   - Optimize resource usage

### Script to monitor disk usage and send alerts
```bash
#!/bin/bash

THRESHOLD=80
ALERT_EMAIL="admin@example.com"

# Check disk usage
DISK_USAGE=$(df -h | grep '/dev/sda1' | awk '{print $5}' | sed 's/%//')

if [ $DISK_USAGE -gt $THRESHOLD ]; then
    # Log details
    echo "Disk usage is $DISK_USAGE%" >> /var/log/disk_usage.log
    df -h >> /var/log/disk_usage.log
    
    # Send alert
    echo "Disk usage is $DISK_USAGE%" | mail -s "Disk Usage Alert" $ALERT_EMAIL
fi
``` 