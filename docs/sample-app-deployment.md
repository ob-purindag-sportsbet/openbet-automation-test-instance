# Deploying the Sample Application

In order to deploy an existing _docker-compose_ based project, follow the steps:

1. Make a copy of the sample playbooks available in the `playbooks` directory.
2. Edit `<your-playbook>.yml` file and update `subnet`, `vpc_id`, `keypair`
 and `keypair_path` properties after referring to your AWS account.
1. Make sure you have a `[default]` AWS profile setup with access keys under your 
 `~/.aws/credentials`.
1. Deploy using `./provisioner launch <your-playbook>.yml`
2. You should be able to access the web interface of the app thought the 
 _Public IP or URL_ of the instance.