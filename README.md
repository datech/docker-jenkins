# docker-jenkins

## Create image

```bash
docker build -t jenkins .
```

## Start container

```bash
docker-compose jenkins up -d
```

### Set list with pre-installed pluging

Update provision/plugins.txt

### Set Jenkins version

Update JENKINS_VERSION in provision/provision.sh
