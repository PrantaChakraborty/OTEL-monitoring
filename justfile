# Start Grafana monitoring stack
# List all available recipes
default:
    @just --list
start-grafana:
    cd monitoring && docker compose up -d

# Stop Grafana monitoring stack
stop-grafana:
    cd monitoring && docker compose down

# Start OpenTelemetry Collector
start-otel:
    cd otel-collector && docker compose up -d

# Stop OpenTelemetry Collector
stop-otel:
    cd otel-collector && docker compose down

# Start all monitoring services
start-all: start-grafana start-otel
    @echo "All monitoring services started"

# Stop all monitoring services
stop-all: stop-otel stop-grafana 
    @echo "All monitoring services stopped"

# Show logs for a container
logs container:
    docker logs {{container}} -f

remove-containers:
    docker rm grafana tempo loki prometheus otel-collector