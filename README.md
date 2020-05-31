# pihole-health
PiHole Health check using systemd and healthcheck.io

## Get Started

Create an account on [https://healthchecks.io](https://healthchecks.io) and
create a check. Take note of the url.

Create a `secrets.mk` file in the project root with the following values.

``` 
pass_url := '<healthcheck.io url>'
pihole_ip := '192.168.0.43'
test_domain := 'example.org'
test_domain_ip := '93.184.216.34'
```

Create virualenv and install systemd services

``` bash
make install
```

Get a mail within 10 minutes of an issue arising with the PiHole.

