@echo off
docker run -it --name="dak" -p 80:80 yukikurosawadev/debian_archive_kit:%1
docker stop dak
docker rm dak