@echo off
cls
docker system df
docker image rm yukikurosawadev/test:%1
docker builder prune -f
docker build -f=Jammy.Dockerfile --tag=yukikurosawadev/test:%1 .
docker system df