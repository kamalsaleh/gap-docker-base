FROM ubuntu:latest

ENV LANG=C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive

# never install suggests or recommends to make the image smaller
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf

# Prerequisites
RUN    dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get -qq install -y \
            autoconf \
            autogen \
            automake \
            build-essential \
            cmake \
            curl \
            g++ \
            gcc \
            #gcc-multilib \
            git \
            #libboost-dev \
            libcdd-dev \
            libcurl4-openssl-dev \
            #libflint-dev \
            #libglpk-dev \
            libgmp-dev \
            libgmpxx4ldbl \
            libmpc-dev \
            libmpfi-dev \
            libmpfr-dev \
            libncurses5-dev \
            #libntl-dev \
            libreadline6-dev \
            libtool \
            #libxml2-dev \
            #libzmq3-dev \
            m4 \
            #mercurial \
            #polymake \
            #python3-pip \
            sudo \
            unzip \
            wget \
            texlive-latex-extra \
            texlive-fonts-extra \
            texlive-science \
            python-is-python3 \
            vim \
            gnupg \
            ca-certificates \
            zlib1g-dev \
            4ti2 \
            singular \
            libnormaliz-dev \
            zip \
            time \
            jupyter-notebook \
            jupyter-nbconvert \
            # needed for getprotobyname used in IO_socket in IO, used for SingleHTTPRequest
            netbase \
            bash-completion \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

RUN    curl -L https://download.arangodb.com/arangodb312/DEBIAN/Release.key | gpg --dearmor > /etc/apt/trusted.gpg.d/arangodb.gpg \
    && echo 'deb [trusted=yes] https://download.arangodb.com/arangodb312/DEBIAN/ /' > /etc/apt/sources.list.d/arangodb.list \
    && apt-get update \
    && apt-get install arangodb3-client

#RUN pip3 install notebook jupyterlab_launcher jupyterlab traitlets ipython vdom

# add gap user, use uid and gid used by GitHub Actions
RUN    addgroup --quiet --gid 121 gap \
    && adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password --uid 1001 --gid 121 gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cd /home/gap \
    && touch .sudo_as_admin_successful

RUN   apt-get update \
    && apt-get install -y gcc python3 python3-pip python3-venv \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists*

ENV PATH="/opt/venv/bin:$PATH"

## CXSC (for Float)
#ENV CXSC_VERSION=2-5-4
#RUN    cd /tmp \
#    && wget http://www2.math.uni-wuppertal.de/wrswt/xsc/cxsc/cxsc-${CXSC_VERSION}.tar.gz \
#    && tar -xf cxsc-${CXSC_VERSION}.tar.gz \
#    && mkdir cxscbuild \
#    && cd cxscbuild \
#    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/tmp/cxsc /tmp/cxsc-${CXSC_VERSION} \
#    && make \
#    && make install
#
## libfplll (for Float)
#ENV FPLLL_VERSION=5.2.1
#RUN    cd /tmp \
#    && wget https://github.com/fplll/fplll/releases/download/${FPLLL_VERSION}/fplll-${FPLLL_VERSION}.tar.gz \
#    && tar -xf fplll-${FPLLL_VERSION}.tar.gz \
#    && rm fplll-${FPLLL_VERSION}.tar.gz \
#    && cd fplll-${FPLLL_VERSION} \
#    && ./configure \
#    && make \
#    && make install \
#    && cd /tmp \
#    && rm -rf fplll-${FPLLL_VERSION}
#
#
## flint (for Singular)
## RUN    cd /tmp \
##     && git clone https://github.com/wbhart/flint2.git \
##     && cd flint2 \
##     && ./configure \
##     && make -j4 \
##     && make install \
##     && cd /tmp \
##     && rm -rf flint2
#
## Singular
#ENV SINGULAR_VERSION=4.1.2
#ENV SINGULAR_PATCH=p1
#RUN    cd /opt \
#    && wget http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/$(echo ${SINGULAR_VERSION} | tr . -)/singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
#    && tar -xf singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
#    && rm singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
#    && chown -hR gap singular-${SINGULAR_VERSION} \
#    && cd singular-${SINGULAR_VERSION} \
#    && ./configure \
#    && make -j4 \
#    && make install
#
## 4ti2
#ENV _4TI2_VERSION=1_6_9
#RUN    cd /opt \
#    && wget https://github.com/4ti2/4ti2/archive/Release_${_4TI2_VERSION}.tar.gz \
#    && tar -xf Release_${_4TI2_VERSION}.tar.gz \
#    && chown -hR gap 4ti2-Release_${_4TI2_VERSION} \
#    && rm Release_${_4TI2_VERSION}.tar.gz \
#    && cd 4ti2-Release_${_4TI2_VERSION} \
#    && chmod +x autogen.sh \
#    && ./autogen.sh \
#    && ./configure \
#    && touch doc/4ti2_manual.pdf \
#    && make -j4 \
#    && make install
#
## Pari/GP
#ENV PARI_VERSION=2.9.5
#RUN    cd /tmp/ \
#    # the https version uses a certificate not trusted by wget
#    && wget http://pari.math.u-bordeaux.fr/pub/pari/OLD/2.9/pari-${PARI_VERSION}.tar.gz \
#    && tar -xf pari-${PARI_VERSION}.tar.gz \
#    && rm pari-${PARI_VERSION}.tar.gz \
#    && cd pari-${PARI_VERSION} \
#    && ./Configure \
#    && make install
#
## Macaulay2
#RUN    . /etc/lsb-release \
#    && echo "deb http://www.math.uiuc.edu/Macaulay2/Repositories/Ubuntu focal main" >/etc/apt/sources.list.d/macaulay2.list \
#    && wget http://www2.macaulay2.com/Macaulay2/PublicKeys/Macaulay2-key \
#    && apt-key add Macaulay2-key \
#    && apt-get update -qq \
#    && apt-get -qq install -y macaulay2

#RUN rm -r /tmp/*

#ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

# /usr/lib/git-core/git-subtree: use bash instead of sh (= dash)
# /usr/lib/git-core/git-subtree fails with "Maximum function recursion depth (1000) reached" for large projects when using dash in Debian/Ubuntu
RUN sed 's|#!/bin/sh|#!/bin/bash|' -i /usr/lib/git-core/git-subtree

# Set up new user and home directory in environment.
USER gap
ENV HOME=/home/gap

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
# Start at $HOME.
WORKDIR /home/gap

# create GAP user root
RUN mkdir -p .gap/pkg

# Temporarily? use stable Julia to avoid nightly incompatibilities with GAP's prebuilt JuliaInterface.
RUN curl -fsSL https://install.julialang.org | sh -s -- \
    --yes \
    --default-channel release \
    --add-to-path=no \
    --startup-selfupdate=0

ENV PATH="/home/gap/.juliaup/bin:${PATH}"

# The following uses the julia nightly builds.
# RUN mkdir -p inst/julia-master && curl -L https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz | tar -xvz --strip-components=1 -C inst/julia-master
# ENV PATH=/home/gap/inst/julia-master/bin:${PATH}

COPY clean_gap_packages.sh /home/gap/clean_gap_packages.sh

RUN mkdir -p .julia/dev
# clone GAP.jl
#RUN git clone https://github.com/oscar-system/GAP.jl .julia/dev/GAP
# clone CapAndHomalg.jl
RUN git clone https://github.com/homalg-project/CapAndHomalg.jl .julia/dev/CapAndHomalg
# clone MatricesForHomalg.jl
RUN git clone https://github.com/homalg-project/MatricesForHomalg.jl .julia/dev/MatricesForHomalg

# ignore compatibility of CapAndHomalg with GAP
#RUN sed -i '/GAP = "0.7/d' .julia/dev/CapAndHomalg/Project.toml

# installation and cleaning has to happen in the some step or we will not get any saving due to the layering system
# use CPU target "generic" to avoid recompilation on different x86_64 CPUs
# Pkg.develop of a cloned package does not trigger Pkg.build (see: https://github.com/JuliaLang/Pkg.jl/issues/4068)
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.add("IJulia"); Pkg.build("IJulia"); using IJulia;'
#RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.develop("GAP"); Pkg.build("GAP"); using GAP;'
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.develop("CapAndHomalg"); Pkg.build("CapAndHomalg"); using CapAndHomalg;'
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.add("JSON3"); Pkg.build("JSON3"); using JSON3;'
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.add("Nemo"); Pkg.build("Nemo"); using Nemo;'
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.add("AbstractAlgebra"); Pkg.build("AbstractAlgebra"); using AbstractAlgebra;'
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.develop("MatricesForHomalg"); Pkg.build("MatricesForHomalg"); using MatricesForHomalg;'
# Documenter is not part of the standard library in Julia
RUN julia --cpu-target "generic" -e 'using Pkg; Pkg.develop("Documenter"); Pkg.build("Documenter"); using Documenter;'
#RUN bash clean_gap_packages.sh

# Start from a BASH shell.
CMD ["bash"]
