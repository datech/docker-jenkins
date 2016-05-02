# docker-jenkins

## Create image

```bash
docker build -t jenkins .
```

## Start container

```bash
docker-compose jenkins up -d
```

### Set list with pre-installed plugins

Update provision/plugins.txt

### Set Jenkins version

Update JENKINS_VERSION in provision/provision.sh

### Pre-created job

To create your own pre-created job, just create a job and use save the config.xml to provision/job-config.xml.
If you need to change the name, just update JENKINS_JOB_NAME in provision/provision.sh
