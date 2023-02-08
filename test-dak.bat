@echo off
docker run -it --privileged --name="dak" -p 5433:5432 -p 80:80 yukikurosawadev/debian_archive_kit:%1
docker stop dak
rem docker rm dak