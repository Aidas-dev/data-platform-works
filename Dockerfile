FROM ubuntu:latest
LABEL authors="aidmantas"

ENTRYPOINT ["top", "-b"]
FROM python:3.11-slim