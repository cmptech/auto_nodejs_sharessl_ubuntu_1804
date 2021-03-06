# https://hub.docker.com/u/cmptech/nodejs_sharessl_ubuntu:18.04

#FROM ubuntu:latest
#FROM ailispaw/ubuntu-essential:latest
FROM cmptech/zt:latest

Maintainer Wanjo Chan ( http://github.com/wanjochan/ )

RUN apt update && apt install -y wget libssl-dev

RUN echo export NODE_VERSION=node-`wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p'` > /node_env.sh

RUN . /node_env.sh \
&& apt install -y python-pip \
&& cd /root/ \
&& wget https://nodejs.org/dist/latest/$NODE_VERSION.tar.gz \
&& tar xzvf $NODE_VERSION.tar.gz \
&& cd $NODE_VERSION \
&& ./configure --prefix=/$NODE_VERSION --shared-openssl \
&& make -j8 \
&& make install \
&& cd /root/ \
&& rm -Rf ${NODE_VERSION}* \
&& apt remove -y python* \
&& apt autoremove -y \
&& rm -rf /var/lib/apt/lists/ \
&& /$NODE_VERSION/bin/node -v

# docker build -t cmptech/nodejs_sharessl_ubuntu:18.04 .
# docker run -ti cmptech/auto_ubuntu1804_nodejs_sharessl bash -c 'source /node_env.sh && /$NODE_VERSION/bin/node -e "console.log(os.arch(),os.platform(),process.versions.modules,process.versions)"'
