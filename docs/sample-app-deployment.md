# Deploying the Sample Application

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