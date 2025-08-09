# Monitoring System Documentation

## Overview
This monitoring system is designed to collect, process, and visualize metrics from various system components. It provides real-time monitoring, alerting, and historical data analysis capabilities.

## Architecture

```mermaid
---
config:
  theme: mc
  look: neo
  layout: dagre
---
flowchart LR
    %% --- Source/Process ----
    Backend("fa:fa-code  **Django Backend**"):::process
    OTEL("fa:fa-satellite-dish  **OTEL Collector**"):::otel

    %% --- Storage ---
    Prometheus("fa:fa-chart-line  **Prometheus**"):::metric
    Loki("fa:fa-database  **Loki**"):::logs
    Tempo("fa:fa-project-diagram  **Tempo**"):::trace

    %% --- Display ---
    subgraph display["**Display**"]
      direction LR
      Grafana("fa:fa-desktop  **Grafana**"):::display
    end

    %% --- Data flow (minimal wires, L->R) ---
    Backend --> OTEL
    OTEL -->|Metrics| Prometheus
    OTEL -->|Logs| Loki
    OTEL -->|Traces| Tempo
    Prometheus -->|Query| Grafana
    Loki -->|Query| Grafana
    Tempo -->|Query| Grafana

    %% --- Visual classes for a modern look ---
    classDef process fill:#ffecb3,stroke:#ffb300,stroke-width:3px,color:#6d4c41, font-weight:bold;
    classDef otel fill:#e0f7fa,stroke:#00bcd4,stroke-width:3px,color:#005662, font-weight:bold;
    classDef metric fill:#ede7f6,stroke:#512da8,stroke-width:3px,color:#1a237e, font-weight:bold;
    classDef logs fill:#fff3e0,stroke:#fb8c00,stroke-width:3px,color:#e65100, font-weight:bold;
    classDef trace fill:#ffebee,stroke:#d32f2f,stroke-width:3px,color:#b71c1c, font-weight:bold;
    classDef display fill:#b2dfdb,stroke:#00897b,stroke-width:3px,color:#004d40, font-weight:bold;

    %% Apply classes
    class Backend process
    class OTEL otel
    class Prometheus metric
    class Loki logs
    class Tempo trace
    class Grafana display

    %% Subgraph background for display
    style display fill:#e0f2f1,stroke:#00897b,stroke-width:3px

```

### Data Flow
1. Django Backend generates telemetry data
2. OpenTelemetry Collector receives:
   - Metrics (OTLP format)
   - Traces (OTLP format)
   - Logs (OTLP format)
3. Data Distribution:
   - Prometheus scrapes metrics from OTel Collector
   - Tempo receives distributed traces
   - Loki ingests log streams
4. Grafana provides unified view:
   - Metrics visualization from Prometheus
   - Trace analysis from Tempo
   - Log exploration from Loki


## Quick Start

1. Clone the repository:
Required *Docker* and *just*
```bash
git clone https://github.com/PrantaChakraborty/OTEL-monitoring.git
```

2. Start all services:
```bash
just start-all
```


3. Access the dashboard:
- Open `http://localhost:3000`
- Login with default credentials 
- Username: admin
- Password: admin

4. Stop all services:
```bash
just stop-all
```

## Backend Configuration
Your backend(Django) needs to send data to the otel collector
otel url is : http://localhost:55690
```bash
    OTEL_RESOURCE_ATTRIBUTES=service.name=satarko \
    OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:55690" \
    OTEL_EXPORTER_OTLP_PROTOCOL=grpc \
    opentelemetry-instrument gunicorn zicore_connect.wsgi:application --workers 2
```

## Project Structure

```
monitoring/
├── docker-compose.yml
├── dashboard/
│   └── loki.json
├── loki/
│   ├── loki-config.yaml
├── prometheus/
│   └── prometheus.yml
├── tempo/
│   └── tempo.yml
otel-collector/
├── docker-compose.yml
└── otel_config.yaml
```

# Project Structure Documentation

## monitoring/
Main monitoring stack directory containing configuration files for observability tools.

### monitoring/docker-compose.yml
Docker Compose configuration for setting up the monitoring stack services.

### monitoring/dashboard/loki.json 
Grafana dashboard configuration file for Loki logs visualization.

### monitoring/loki/loki-config.yaml
Configuration file for Loki log aggregation system.

### monitoring/prometheus/prometheus.yml
Prometheus configuration file defining scrape targets and metrics collection.

### monitoring/tempo/tempo.yml
Configuration file for Tempo distributed tracing backend.

## otel-collector/
OpenTelemetry Collector configuration directory.

### otel-collector/docker-compose.yml
Docker Compose file for OpenTelemetry Collector deployment.

### otel-collector/otel_config.yaml
OpenTelemetry Collector configuration defining data collection and export pipelines.



