# THIS REPO IS NOT MAINTAINED

New repository is hosted at https://bitbucket.openbet.com/projects/SBT/repos/container-host-provisioner/browse?at=main


# Container Host Machine Provisioner

For project goals and objectives, please refer to the Wiki article here
https://wiki.openbet.com/display/SBP/SBT-41661+Automation+Test+Framework+Decoupling 

This playbook has only *one* purpose and one alone which is to provision 
Amazon EC2 instances or local machines as docker hosts which runs the OpenBet applications stack used
for running automation tests.

The deploy.yml playbook creates an instance or instances required and provisions it 
if doesn't exist, then starts up the applications stack.


## Installation & Setup

This project uses python `virtualenv` package to separate project dependencies
from rest of your python modules/configuration on your system.

Run the following to setup the virtualenv and install project dependencies

> `./provisioner setup`

Project requires `python >= 3`.

Note: following is a list of dependencies that the install script will pull into
the virtual environment.

    * Ansible>=2.0,<3.0
    * boto

## Usage

The  provided playbooks are located under `playbooks` directory.

Currently, there are two plaubooks available:
1. Localhost provisioning
2. AWS provisioning

In order to create a new playbook, follow the steps:
1. Create a new playbook under `playbooks` directory or anywhere you prefer.
2. Update the playbook with the required parameters.
3. Run the playbook using `./provisioner launch <playbook>.yml`

Key points to remember when deploying a new playbook:
1. If deploying to AWS cloud, make sure you have a `[default]` AWS profile setup with access keys under your 
 `~/.aws/credentials`.
2. You should be able to access the web interface of the app thought the 
 _Public IP or URL_ of the instance (controlled by the `enable_http` configuration).

#### AWS Authentication

`aws_profile` variable is used by the playbook to access the AWS credentials and
other information stored against profiles in `~/.aws/credentials` file. 
Using this way another authentication key generation tool or a script can be 
combined with the playbook. The external script/app needs to write a 
profile section under `~/.aws/credentials` which playbook will use. 


## What it does

**For AWS provisioning**, the playbook does the following which is defined by the configuration `target` in the playbook.
Running the playbook: `$ ./provisioner launch playbooks/automation-instance.yml` does the following:

1. Creates an instance (if doesnt exist based on tags used) as per the `automation-instance.yml`.
2. Installs Docker-Engine, Docker-Compose and other software dependancies on the node.
3. Runs tasks such as docker and compose (via openbet stack CLI)

**For local provisioning**, the playbook does the following:
1. Ansible playbook runs on the localhost and provisions the localhost as a docker host.
2. Makes sure the docker-engine and docker-compose are installed.
3. Runs tasks such as docker and compose (via openbet stack CLI)

### Additional Documentation

* [Configuring Your Docker App for AWS](docs/aws-docker-app-configuration.md)
* [Deploying the Sample Application](docs/sample-app-deployment.md)
