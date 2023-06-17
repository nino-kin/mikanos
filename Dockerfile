# Dockerfile

FROM python:3

# Install necessary packages
RUN pip install mkdocs

# make directory for MkDocs
WORKDIR /docs

# Cpoy the document of host machine into the docker container
COPY . /docs

# Build documents and run a server
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
