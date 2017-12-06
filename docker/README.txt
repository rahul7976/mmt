Installation Instructions

1) Download Docker Community Edition from:
https://www.docker.com/community-edition

2) Download the latest CMR Dev System Uber Jar from:
https://ci.earthdata.nasa.gov/browse/CMR-CSB/latestSuccessful/artifact/
Find this file and download it:
cmr-dev-system-uberjar.jar
Put this file in mmt/docker/libs

3) To build the mmt docker image, type:
sh build.sh

4) To launch the mmt docker image, type:
sh run.sh
Port 3000 will be accessible

5) To access MMT, go to:
http://localhost:3000


