@echo off
cls
docker system df
docker image rm yukikurosawadev/debian_archive_kit:%1
rem docker builder prune -f
docker build -f=DAK.Dockerfile --tag=yukikurosawadev/debian_archive_kit:%1 .
docker system df