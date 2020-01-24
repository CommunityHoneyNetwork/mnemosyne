FROM ubuntu:18.04

LABEL maintainer Alexander Merck <alexander.t.merck@gmail.com>
LABEL name "chn-mnemosyne"
LABEL version "0.1"
LABEL release "1"
LABEL summary "Community Honey Network mnemosyne server"
LABEL description "mnemosyne is a normalizer for honeypot data."
LABEL authoritative-source-url "https://github.com/CommunityHoneyNetwork/mnemosyne/commits/master"
LABEL changelog-url "https://github.com/CommunityHoneyNetwork/mnemosyne/commits/master"

ENV HPFEEDS_HOST=hpfeeds3
ENV HPFEEDS_PORT=10000
ENV MONGODB_HOST=mongodb
ENV MONGODB_PORT=27017
ENV OWNER=chn
ENV IDENT=mnemosyne
ENV CHANNELS=amun.events,conpot.events,thug.events,beeswarm.hive,dionaea.capture,dionaea.connections,thug.files,beeswarm.feeder,cuckoo.analysis,kippo.sessions,cowrie.sessions,glastopf.events,glastopf.files,mwbinary.dionaea.sensorunique,snort.alerts,wordpot.events,p0f.events,suricata.events,shockpot.events,elastichoney.events,rdphoney.sessions,uhp.events
ENV IGNORE_RFC1918=False
ENV MONGODB_INDEXTTL=2592000

ADD requirements.txt /opt/requirements.txt

RUN apt-get update && apt-get install -y gcc git sqlite mongodb python3-dev python3-pip
RUN pip3 install -r /opt/requirements.txt
RUN pip3 install git+https://github.com/CommunityHoneyNetwork/hpfeeds3.git

COPY . /opt/

RUN pip3 show hpfeeds3

CMD python3 /usr/local/lib/python3.6/dist-packages/hpfeeds/add_user.py --mongodb-host ${MONGODB_HOST} --mongodb-port ${MONGODB_PORT} \
        --owner ${OWNER} --ident ${IDENT} --secret ${SECRET} \
        --publish "" --subscribe ${CHANNELS} \
    && python3 /opt/scripts/build_config.py --template "/opt/templates/mnemosyne.cfg.template" --config "/opt/mnemosyne.cfg" \
        --ident ${IDENT} --secret ${SECRET} --hpfeeds-host ${HPFEEDS_HOST} --hpfeeds-port ${HPFEEDS_PORT} \
        --channels ${CHANNELS} --mongodb-host ${MONGODB_HOST} --mongodb-port ${MONGODB_PORT} \
        --mongodb-ttl ${MONGODB_INDEXTTL} --rfc1918 ${IGNORE_RFC1918} \
    && cd /opt/mnemosyne \
    && /usr/bin/env python3 /opt/mnemosyne/runner.py --config /opt/mnemosyne.cfg
