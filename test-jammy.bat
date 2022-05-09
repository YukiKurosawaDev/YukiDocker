@echo off
docker run -it --name="test" yukikurosawadev/test:%1
docker stop test
docker rm test