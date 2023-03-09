# Request Tracker 5 Docker

## Usage
docker run  bywatersolutions/rt5:latest
```bash
docker run -d  \
    --name rt5 \
    -v /opt/rt5/etc/RT_SiteConfig.d/:/opt/rt/etc/RT_SiteConfig.d/ \
    -p 8001:8000 \
    --network my_nw \
    quay.io/bywatersolutions/rt5-docker:latest
```
