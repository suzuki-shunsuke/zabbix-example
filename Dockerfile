FROM zabbix/zabbix-agent:ubuntu-3.2.4
COPY requirements.txt /tmp/
COPY supervisord_flask.conf /etc/supervisor/conf.d/
RUN apt-get update && \
    apt-get install -y curl && \
    curl -q https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install -r /tmp/requirements.txt && \
    mkdir -p /usr/src/app && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/achives
WORKDIR /usr/src/app
COPY main.py /usr/src/app/
