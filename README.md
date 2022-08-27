# Prometheus Redis Metrics Exporter

Prometheus exporter for Redis metrics.\
Supports Redis 2.x, 3.x, 4.x, 5.x, 6.x, and 7.x

### Basic Prometheus Configuration

Add a block to the `scrape_configs` of your prometheus.yml config file:

```yaml
scrape_configs:
  - job_name: redis_exporter
    static_configs:
    - targets: ['<<REDIS-EXPORTER-HOSTNAME>>:9121']
```

### Prometheus Configuration to Scrape Multiple Redis Hosts

Run the exporter with the command line flag `--redis.addr=` so it won't try to access the local instance every time the `/metrics` endpoint is scraped. Using below config instead of the /metric endpoint the /scrape endpoint will be used by prometheus. Example:
* `http://exporterhost:9121/scrape?target=first-redis-host:6379`

```yaml
scrape_configs:
  ## config for the multiple Redis targets that the exporter will scrape
  - job_name: 'redis_exporter_targets'
    static_configs:
      - targets:
        - redis://first-redis-host:6379
        - redis://second-redis-host:6379
        - redis://second-redis-host:6380
        - redis://second-redis-host:6381
    metrics_path: /scrape
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: <<REDIS-EXPORTER-HOSTNAME>>:9121

  ## config for scraping the exporter itself
  - job_name: 'redis_exporter'
    static_configs:
      - targets:
        - <<REDIS-EXPORTER-HOSTNAME>>:9121
```

You can also use a json file to supply multiple targets by using `file_sd_configs`:

```yaml

scrape_configs:
  - job_name: 'redis_exporter_targets'
    file_sd_configs:
      - files:
        - targets-redis-instances.json
    metrics_path: /scrape
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: <<REDIS-EXPORTER-HOSTNAME>>:9121

  ## config for scraping the exporter itself
  - job_name: 'redis_exporter'
    static_configs:
      - targets:
        - <<REDIS-EXPORTER-HOSTNAME>>:9121
```

The `targets-redis-instances.json` should look something like this:

```json
[
  {
    "targets": [ "redis://redis-host-01:6379", "redis://redis-host-02:6379"],
    "labels": { }
  }
]
```

Prometheus uses file watches and all changes to the json file are applied immediately.

* Redis instance addresses can be tcp addresses: `redis://localhost:6379`, `redis.example.com:6379` or e.g. unix sockets: `unix:///tmp/redis.sock`.
* SSL is supported by using the `rediss://` schema, for example: `rediss://azure-ssl-enabled-host.redis.cache.windows.net:6380` (note that the port is required when connecting to a non-standard 6379 port, e.g. with Azure Redis instances).\

### Authenticating with Redis

If your Redis instance requires authentication then there are several ways how you can supply a username (new in Redis 6.x with ACLs) and a password.

You can provide the username and password as part of the address, see [here](https://www.iana.org/assignments/uri-schemes/prov/redis) for the official documentation of the `redis://` scheme.

* You can set `-redis.password-file=sample-pwd-file.json` to specify a password file, it's used whenever the exporter connects to a Redis instance, no matter if you're using the `/scrape` endpoint for multiple instances or the normal `/metrics` endpoint when scraping just one instance.
* It only takes effect when `redis.password == ""`.  See the [contrib/sample-pwd-file.json](contrib/sample-pwd-file.json) for a working example, and make sure to always include the `redis://` in your password file entries.
* An example for a URI including a password is: `redis://<<username (optional)>>:<<PASSWORD>>@<<HOSTNAME>>:<<PORT>>`
* Alternatively, you can provide the username and/or password using the `--redis.user` and `--redis.password` directly to the redis_exporter.
* If you want to use a dedicated Redis user for the redis_exporter (instead of the default user) then you need enable a list of commands for that user. You can use the following Redis command to set up the user, just replace `<<<USERNAME>>>` and `<<<PASSWORD>>>` with your desired values.
```
ACL SETUSER <<<USERNAME>>> +client +ping +info +config|get +cluster|info +slowlog +latency +memory +select +get +scan +xinfo +type +pfcount +strlen +llen +scard +zcard +hlen +xlen +eval allkeys on > <<<PASSWORD>>>
```
## Official documentation

Please look on maintainer repo-page:
* https://github.com/oliver006/redis_exporter
