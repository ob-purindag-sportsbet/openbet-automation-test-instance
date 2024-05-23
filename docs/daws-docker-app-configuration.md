# Configuring Your Docker App for DAWS

You can deploy new or existing docker-compose based applications to AWS easily following the instructions on this page.

The toolkit is meant to be simple and the steps it follows to get your application started on AWS (EC2) are same as what you would normally follow to get your app started on your localhost using docker and docker-compose.

DAWS Toolkit makes the provisioning and configuration of the server which the docker app runs extremely easy by using an ansible playbook behind the scenes.

### Configuration

A typical docker-compose application has one or more service defined within a file named `docker-compose.yml`, the file is a service definition system for docker, nothing else.

The services defined within the `docker-compose.yml` may or may not expose a web application, if it does then the application should be running on port 80 or 443 for the outside world to access / browse the application. The daws toolkit uses the same exposed ports for making sure the web/http service available for requests coming into the EC2 instance that the docker-compose application runs on.

Usually a web service application could have a `docker-compose.yml` similar to the one below (sample project link).

```c
version: '3'

services:
  product-service:
    build: ./product
    volumes:
      - ./product:/usr/src/app
    ports:
      - 5001:8080

  website:
    image: php:apache
    volumes:
      - ./website:/var/www/html
    ports:
      - 80:80
    depends_on:
      - product-service
```

You can learn more about the syntax for docker-compose on this URL <https://docs.docker.com/compose/compose-file/>

The notable requirements in a docker-compose.yml for daws toolkit are

1. Port Mapping
2. Container Volumes

### Port Mapping

This section is essential for the docker-compose.yml to work correctly after deploying with daws and serve incoming requests (if you are deploying a web application). Ports that are mapped to the host will be accessible if the security group is configured to expose the particular port to outside world.

Ex: sample.yml file from the Sample Project

```c
# Security group rules
security_group:
  incoming_rules:
    - proto: tcp
      from_port: 80
      to_port: 80
      cidr_ip: 0.0.0.0/0
    - proto: tcp
      from_port: 443
      to_port: 443
      cidr_ip: 0.0.0.0/0
    - proto: tcp
      from_port: 22
      to_port: 22
      cidr_ip: 0.0.0.0/0
```

The above security group allows port :80 and :443 (HTTP and HTTPS) on the EC2 instance[s] to be exposed to the outside world (`0.0.0.0`), which will let any incoming requests to be served through those ports. Similarly you can customise the ports that you expose from `docker-compose` whether they need to be exposed to specific IP range or the any remote connection.