FROM quay.io/openshift/origin-cli:4.2.0

ARG ocpythonlibver=0.8.6

# Dependencies for openshift-restclient-python.
RUN \
  cd /tmp && \
  curl -s -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python /tmp/get-pip.py && \
  pip install setuptools==40.8.0 urllib3==1.24.1 chardet==3.0.4 requests==2.21.0

# Install restclient from source
RUN \
  cd /tmp && \ 
  curl -s -LO https://github.com/openshift/openshift-restclient-python/archive/v${ocpythonlibver}.tar.gz && \
  tar xvzf v${ocpythonlibver}.tar.gz && \
  cd openshift-restclient-python-${ocpythonlibver} && \
  python setup.py install

RUN  pip install prometheus_client paramiko pyyaml boto3 slackclient && mkdir /openshift-python

CMD [ "/bin/sh" ]