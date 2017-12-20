kafka_exporter
==============

Kafka exporter for Prometheus. For other metrics from Kafka, have a look at the [JMX exporter](https://github.com/prometheus/jmx_exporter).

Table of Contents
-----------------

-	[Compatibility](#compatibility)
-	[Dependency](#dependency)
-	[Download](#download)
-	[Compile](#compile)
	-	[build binary](#build-binary)
	-	[build docker image](#build-docker-image)
-	[Run](#run)
	-	[run binary](#run-binary)
	-	[run docker image](#run-docker-image)
-	[Options](#options)
-	[Metrics](#metrics)
	-	[Brokers](#brokers)
	-	[Topics](#topics)
	-	[Consumer Groups](#consumer-groups)

Compatibility
-------------

Support [Apache Kafka](https://kafka.apache.org) version 0.10.1.0 (and later).

Dependency
----------

-	[Prometheus](https://prometheus.io)
-	[Sarama](https://shopify.github.io/sarama)
-	[Golang](https://golang.org)
-	[Dep](https://github.com/golang/dep)


Compile
-------

### build binary

```shell
go get
go build
```

### build docker image

```shell
docker build -t kafka_exporter_tls:alpine .
```

Docker Hub Image
----------------

```shell
docker pull danimm85/kafka_exporter_tls:alpine
```

It can be used directly instead of having to build the image yourself.

Run
---

### run binary

```shell
./kafka_exporter --tls.enabled --certFile=certs/cert.crt --keyFile=certs/cert.key --caFile=certs/ca.crt --kafka.server=broker-0001:9092

```

### run docker image

```
docker run -d --volume /path/to/certs:/path/to/certs:ro --volume /etc/hosts:/etc/hosts:ro --name kafka_exporter_tls kafka_exporter_tls:alpine --tls.enabled --certFile=certs/cert.crt --keyFile=certs/cert.key --caFile=certs/ca.crt --kafka.server=broker-0001:9092

```

Flags
-----

This image is configurable using different flags

| Flag name          | Default    | Description                                          |
| ------------------ | ---------- | ---------------------------------------------------- |
| kafka.server       | kafka:9092 | Addresses (host:port) of Kafka server                |
| topic.filter       | .*         | Regex that determines which topics to collect        |
| web.listen-address | :9308      | Address to listen on for web interface and telemetry |
| web.telemetry-path | /metrics   | Path under which to expose metrics                   |

Metrics
-------

Documents about exposed Prometheus metrics.

For details on the underlying metrics please see [Apache Kafka](https://kafka.apache.org/documentation).

### Brokers

**Metrics details**

| Name            | Exposed informations                   |
| --------------- | -------------------------------------- |
| `kafka_brokers` | Number of Brokers in the Kafka Cluster |

**Metrics output example**

```txt
# HELP kafka_brokers Number of Brokers in the Kafka Cluster.
# TYPE kafka_brokers gauge
kafka_brokers 3
```

### Topics

**Metrics details**

| Name                                               | Exposed informations                                |
| -------------------------------------------------- | --------------------------------------------------- |
| `kafka_topic_partitions`                           | Number of partitions for this Topic                 |
| `kafka_topic_partition_current_offset`             | Current Offset of a Broker at Topic/Partition       |
| `kafka_topic_partition_oldest_offset`              | Oldest Offset of a Broker at Topic/Partition        |
| `kafka_topic_partition_in_sync_replica`            | Number of In-Sync Replicas for this Topic/Partition |
| `kafka_topic_partition_leader`                     | Leader Broker ID of this Topic/Partition            |
| `kafka_topic_partition_leader_is_preferred`        | 1 if Topic/Partition is using the Preferred Broker  |
| `kafka_topic_partition_replicas`                   | Number of Replicas for this Topic/Partition         |
| `kafka_topic_partition_under_replicated_partition` | 1 if Topic/Partition is under Replicated            |

**Metrics output example**

```txt
# HELP kafka_topic_partitions Number of partitions for this Topic
# TYPE kafka_topic_partitions gauge
kafka_topic_partitions{topic="__consumer_offsets"} 50

# HELP kafka_topic_partition_current_offset Current Offset of a Broker at Topic/Partition
# TYPE kafka_topic_partition_current_offset gauge
kafka_topic_partition_current_offset{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_oldest_offset Oldest Offset of a Broker at Topic/Partition
# TYPE kafka_topic_partition_oldest_offset gauge
kafka_topic_partition_oldest_offset{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_in_sync_replica Number of In-Sync Replicas for this Topic/Partition
# TYPE kafka_topic_partition_in_sync_replica gauge
kafka_topic_partition_in_sync_replica{partition="0",topic="__consumer_offsets"} 3

# HELP kafka_topic_partition_leader Leader Broker ID of this Topic/Partition
# TYPE kafka_topic_partition_leader gauge
kafka_topic_partition_leader{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_leader_is_preferred 1 if Topic/Partition is using the Preferred Broker
# TYPE kafka_topic_partition_leader_is_preferred gauge
kafka_topic_partition_leader_is_preferred{partition="0",topic="__consumer_offsets"} 1

# HELP kafka_topic_partition_replicas Number of Replicas for this Topic/Partition
# TYPE kafka_topic_partition_replicas gauge
kafka_topic_partition_replicas{partition="0",topic="__consumer_offsets"} 3

# HELP kafka_topic_partition_under_replicated_partition 1 if Topic/Partition is under Replicated
# TYPE kafka_topic_partition_under_replicated_partition gauge
kafka_topic_partition_under_replicated_partition{partition="0",topic="__consumer_offsets"} 0
```

### Consumer Groups

**Metrics details**

| Name                                 | Exposed informations                                          |
| ------------------------------------ | ------------------------------------------------------------- |
| `kafka_consumergroup_current_offset` | Current Offset of a ConsumerGroup at Topic/Partition          |
| `kafka_consumergroup_lag`            | Current Approximate Lag of a ConsumerGroup at Topic/Partition |

**Metrics output example**

```txt
# HELP kafka_consumergroup_current_offset Current Offset of a ConsumerGroup at Topic/Partition
# TYPE kafka_consumergroup_current_offset gauge
kafka_consumergroup_current_offset{consumergroup="KMOffsetCache-kafka-manager-3806276532-ml44w",partition="0",topic="__consumer_offsets"} -1

# HELP kafka_consumergroup_lag Current Approximate Lag of a ConsumerGroup at Topic/Partition
# TYPE kafka_consumergroup_lag gauge
kafka_consumergroup_lag{consumergroup="KMOffsetCache-kafka-manager-3806276532-ml44w",partition="0",topic="__consumer_offsets"} 1
```
