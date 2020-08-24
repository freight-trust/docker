# SonarHusky

### SonarQube

Find the Community Edition Docker image on Docker Hub.

Start the server by running:

[hub.docker.com/_/sonarqube/](https://hub.docker.com/_/sonarqube/)

$ docker run -d --name sonarqube -p 9000:9000 <image_name>
> image names: 8.4.1-community, 8.4-community, 8-community, community, latest

Log in to http://localhost:9000 with System Administrator credentials (login=admin, password=admin).
```
$ docker run --stop-timeout 3600 sonarqube
```

## Customized image
In some environments, it may make more sense to prepare a custom image containing your configuration. A Dockerfile to achieve this may be as simple as:
```dockerfile
FROM sonarqube:8.2-community
COPY sonar.properties /opt/sonarqube/conf/
```

You could then build and try the image with something like:

`$ docker build --tag=sonarqube-custom . `
`$ docker run -ti sonarqube-custom `