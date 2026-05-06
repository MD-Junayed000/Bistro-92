# Bistro-92

Bistro-92 is a modern restaurant management system that combines Go microservices, a React frontend, and event-driven workflows to power ordering, notifications, and analytics.

## Highlights

- Microservices for orders, notifications, and dashboards
- Real-time updates via WebSockets, RabbitMQ, and Temporal workflows
- PostgreSQL + Redis for persistence and caching
- React UI with charts and dashboards
- Docker Compose for one-command local setup

## Architecture & Workflows

![Bistro-92 Architecture Diagram 1](./assets/image1.png)
![Bistro-92 Architecture Diagram 2](./assets/image2.png)
![Bistro-92 Architecture Diagram 3](./assets/image3.png)

The system consists of the following components:

- **Order Service**: Handles customer orders, menu management, and payment processing
- **Notification Service**: Manages communication with customers and staff
- **Dashboard Service**: Provides analytics and reporting capabilities
- **Frontend**: User interface for customers and restaurant staff

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MD-Junayed000/Bistro-92.git
   cd bistro-92
   ```

2. Start the services:
   ```bash
   docker-compose up -d
   ```

3. Initialize the database (if not done automatically):
   ```bash
   docker-compose exec postgres psql -U postgres -d bistro92 -f /docker-entrypoint-initdb.d/init.sql
   ```

4. Access the services:
   - Frontend: http://localhost:3000
   - Order Service API: http://localhost:8000
   - Notification Service API: http://localhost:3001
   - Dashboard Service: http://localhost:5000
   - RabbitMQ Management: http://localhost:15672 (user: guest, password: guest)
   - Temporal UI: http://localhost:8085
   - Adminer (Database Management): http://localhost:4040
  


### Repository structure

```
.
├── assets/                     # Architecture + UI images
├── bistro92-backend/
│   ├── order-service/          # Orders, menu, tables
│   ├── notification-service/   # WebSocket + RabbitMQ notifications
│   └── dashboard-service/      # Metrics + Redis cache
├── frontend/                   # React UI
└── docker-compose.yml          # Local environment
```
## Services

### Order Service

The Order Service is responsible for processing customer orders, managing the menu, and handling payment processing. It communicates with the PostgreSQL database and uses RabbitMQ for event-driven communication with other services.

- **Port**: 8000
- **Dependencies**: PostgreSQL, RabbitMQ, Temporal

### Notification Service

The Notification Service handles all communication with customers and staff, including order confirmations, updates, and marketing messages. It integrates with external communication providers for SMS, email, and push notifications.

- **Port**: 3001
- **Dependencies**: RabbitMQ, Temporal

### Dashboard Service

The Dashboard Service provides analytics and reporting capabilities, helping restaurant managers make data-driven decisions. It processes data from other services and presents it in an intuitive dashboard.

- **Port**: 5000
- **Dependencies**: PostgreSQL, Redis

### Frontend

The frontend provides a user-friendly interface for customers to place orders and for restaurant staff to manage operations. It communicates with the backend services via APIs.

- **Port**: 3000
- **Dependencies**: Order Service, Notification Service, Dashboard Service

## Database Schema

The database schema is initialized using the SQL script in `bistro92-backend/order-service/db/schema.sql`. This creates the necessary tables for orders, menu items, customers, and other entities.

![Bistro-92 UI Preview 1](./assets/image5.png)
![Bistro-92 UI Preview 2](./assets/image6.png)

### Service ports

| Service | Port | Notes |
| --- | --- | --- |
| Frontend | 3000 | React UI |
| Order Service | 8000 | REST API |
| Notification Service | 3001 | WebSocket + REST |
| Dashboard Service | 5000 | Metrics API |
| PostgreSQL | 5432 | Database |
| RabbitMQ | 5672 / 15672 | Broker + management UI |
| Redis | 6379 | Cache |
| Temporal | 7233 / 8085 | Workflow engine + UI |
| Adminer | 4040 | DB browser |

## Services at a Glance

- **Order Service**: Menu, table, and order lifecycle endpoints; persists to PostgreSQL and emits events.
- **Notification Service**: Consumes RabbitMQ events, triggers Temporal workflows, and pushes WebSocket notifications.
- **Dashboard Service**: Aggregates metrics, caches results in Redis, and serves analytics endpoints.
- **Frontend**: Customer + staff UI with charts and operational views.
