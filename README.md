# vnc2flv-docker

[![Docker Build Status](https://img.shields.io/docker/build/saulshanabrook/vnc2flv.svg)](https://hub.docker.com/r/saulshanabrook/vnc2flv/)
[![](https://images.microbadger.com/badges/image/saulshanabrook/vnc2flv.svg)](https://microbadger.com/images/saulshanabrook/vnc2flv "Get your own image badge on microbadger.com")


Docker Image for recording VNC sessions.

Simple wrapper around the [`vnc2flv` Python package](http://www.unixuser.org/~euske/python/vnc2flv/),
adding an entrypoint to save the `PASSWORD` env var in the `./pwd` file, because
`flvrec.py` requires the password to be in a file.

You can use this with the [Selenium debug images](https://github.com/SeleniumHQ/docker-selenium) to record what happens in them:

```bash
docker network create --driver bridge isolated_nw
docker run --rm --network=isolated_nw --name selenium -d selenium/standalone-chrome-debug
docker run --rm --network=isolated_nw --name rec -v $PWD:/tmp/output/ -e PASSWORD=secret saulshanabrook/vnc2flv flvrec.py -o /tmp/output/rec.flv -P pwd selenium 5900
^C
```

Or you can use this in your `docker-compose.yml` file:

```yaml
version: '2'
services:
  selenium:
    image: selenium/standalone-chrome-debug:3.4.0
  selenium-rec:
    image: saulshanabrook/vnc2flv
    command: ./wait-for selenium:5900 -- flvrec.py -o /tmp/output/rec.flv -P pwd selenium 5900
    volumes:
      - .:/tmp/output/
    depends_on:
      - selenium
    environment:
      PASSWORD: secret
```

And do something with it:

```bash
docker-compose up -d selenium-rec selenium
# interact with the selenium image
docker-compose stop selenium-rec
```

Now you should have a `rec.flv` in your current directory.
