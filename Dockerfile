FROM centos

# Update the base system
RUN yum -y update

# Install Python 3
RUN yum -y install centos-release-scl

RUN yum -y install rh-python36

RUN yum groups mark convert

RUN yum -y groupinstall 'Development Tools'

# Install OpenSSL
RUN yum -y install wget pcre-devel zlib-devel
RUN wget https://ftp.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz && \
    tar xvf openssl-1.1.1.tar.gz 

RUN cd openssl-1.1.1 && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && \
    make && \
    make install

COPY openssl.sh /etc/profile.d/
COPY openssl-1.1.1.conf /etc/ld.so.conf.d/
RUN ldconfig -v

# Required for psycopg2 installation
RUN yum install -y postgresql postgresql-devel

# Create a default user and home directory
ENV NAME pyuser
ENV HOME /home/$NAME
RUN useradd -d $HOME -s /bin/bash -u 10000 -U -p $NAME $NAME && \
    mkdir $HOME/.jupyter && \
    mkdir $HOME/.cert

COPY bashrc.sh $HOME/.bashrc
COPY jupyter_notebook_config.py $HOME/.jupyter
COPY create_hashed_password.py $HOME
RUN chown -R $NAME:$NAME $HOME

# Create shared directory
RUN mkdir /share && \
    chown -R $NAME:$NAME /share

# Switch to the default user from this point
USER $NAME
WORKDIR $HOME

# Create virtual environment with JupyterLab
# Switching to a different shell to specifically use our Python 3 install
SHELL ["/usr/bin/scl", "enable", "rh-python36"]
RUN virtualenv bot_engine --python=python3 && \
    cd bot_engine && \
    source bin/activate && \
    pip install jupyterlab

# Add security and certificates to Jupyter
RUN cd $HOME/.cert && \
    /usr/local/openssl/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "mycert.key" -out "mycert.pem" -batch
RUN cd $HOME && python create_hashed_password.py

EXPOSE 8888
VOLUME /share

CMD ["bash"]

