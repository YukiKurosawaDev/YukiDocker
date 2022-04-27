@echo off
cls
docker system df
rem docker builder prune -f
docker build --tag=yukikurosawadev/test:%1 .
docker system df