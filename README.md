# Docker Provisioning for EC2 instances

This playbook has only *one* purpose and one alone which is to provision 
docker-_compose_ projects easily on Amazon EC2 service _regardless of the AMI or 
linux distribution used_. 

The deploy.yml playbook creates an instance or instances required and deploys 
application and `docker-composer up -d` it.


## Installation & Setup

This project uses python `virtualenv` package to separate project dependencies
from rest of your python modules/configuration on your system.

Run the following to setup the virtualenv and install project dependencies

> `./daws setup`

Project requires `python >= 2.7`.

Note: following is a list of dependencies that the install script will pull into
the virtual environment.

    * Ansible>=2.0,<3.0
    * boto


## Usage

Your _docker-compose_ project can be placed anywhere in your localhost, what is 
required is for you to configure the parameters in the deployment YML which you 
will create using the following steps.

Deployment configuration has to be a `yml` file that you feed to the `launch` 
command. Make a copy of the sample file provided as below

> `cp project_vars.yml.sample project-abc-deploy.yml`


#### Project Configuration

Change the parameters in `project-abc-deploy.yml` to setup security groups and 
instance to fit the AWS account you have.

Following mandatory paths for the deployment config needs to be updated for 
successfully deploying the  _docker-compose_ application.

```
# Project specific parameters
project_prefix: "abc"           # this could be abbreviation of your company
project_name: "ABC Project 1"   # human-readable project name used for resource tagging

project_dirs: 
  src: ./app.sample/
  dest: /opt/app
```


#### AWS Authentication

`aws_profile` variable is used by the playbook to access the AWS credentials and
other information stored against profiles in `~/.aws/credentials` file. 
Using this way another authentication key generation tool or a script can be 
combined with the playbook. The external script/app needs to write a 
profile section under `~/.aws/credentials` which playbook will use. 


## What it does

Running the playbook: `$ ./daws launch project-abc-deploy.yml` does the following:

1. Creates an instance based on the `project-abc-deploy.yml` with a security 
 group as per configuration.
3. Installs Docker-Engine, Docker-Machine and Docker-Compose on the node.
4. Runs tasks such as docker and compose

## Deploying the Sample Application

The sample application provided is located under `docs/sample/app.sample.` directory.
This is a _docker-compose_ version 3 based Python + PHP application which has an
Flask API and a PHP based frontend for demo purposes.

In order to deploy this, follow the steps:

1. `cp project_vars.yml.sample project-sample-app.yml`
2. Edit `project-sample-app.yml` file and update `subnet`, `vpc_id`, `keypair`
 and `keypair_path` properties after referring to your AWS account.
3. Make sure you have a `[default]` AWS profile setup with access keys under your 
 `~/.aws/credentials`.
4. Deploy using `./daws launch project-sample-app.yml`
5. You should be able to access the web interface of the app thought the 
 _Public IP or URL_ of the instance.
