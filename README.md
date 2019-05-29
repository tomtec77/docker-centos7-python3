# CentOS 7 Image with Python 3

To build the image:

``` bash
sudo docker build . -t tomtec/centospy
```

Run a container with:

``` bash
sudo docker run -it --rm --user pyuser -p 8888:8888 -v /your/shared/directory:/share tomtec/centospy3
```

## Directory sharing
To give ownership of the shared volume to user `pyuser` in the container, you
need to do the following on the host machine. First, create the directory to
share, then change its ownership using the **numeric** user and group IDs to
match those of the user in the container (which is 10000, as set in the 
`Dockerfile`).

``` bash
mkdir -p /your/shared/directory
sudo chown -R 10000:10000 /your/shared/directory
```

To run a JupyterLab notebook server inside the container (using Bash terminals):

``` bash
source bot_engine/bin/activate
export SHELL=/bin/bash && jupyter lab --ip=0.0.0.0
```

JupyterLab can be accessed at https://localhost:8888 (note that it's HTTPS). 
The certificates aren't produced by a trusted provider known to the browser, so
you will see a warning that "Your connection is not private". Click on 
"Advanced", then on "Proceed to localhost (unsafe)' to continue.
