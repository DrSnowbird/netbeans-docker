FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

## -------------------------------------------------------------------------------
## ---- USER_NAME is defined in parent image: openkbs/jdk-mvn-py3-x11 already ----
## -------------------------------------------------------------------------------
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}
ENV PRODUCT_WORKSPACE=${HOME}/workspace

## --------------------------------------------------
## ---- To change per different Product detail:  ----
## --------------------------------------------------

## -- 0.) Product Download Mirror site: -- ##
## http://mirror.cc.columbia.edu/pub/software/apache/incubator/netbeans/incubating-netbeans-java/incubating-10.0/incubating-netbeans-java-10.0-bin.zip
## http://mirror.cc.columbia.edu/pub/software/apache/incubator/netbeans/incubating-netbeans/incubating-10.0/incubating-netbeans-10.0-bin.zip
ARG PRODUCT_MIRROR_SITE_URL=${PRODUCT_MIRROR_SITE_URL:-http://www-us.apache.org/dist}

## -- 1.) Product version: -- ##
ARG PRODUCT_VERSION=${PRODUCT_VERSION:-10.0}
ENV PRODUCT_VERSION=${PRODUCT_VERSION}

## -- 2.) Product Category: -- ##
ARG PRODUCT_CATEGORY=${PRODUCT_CATEGORY:-"incubator"}

## -- 3.) Product Name: -- ##
ARG PRODUCT_NAME=${PRODUCT_NAME:-"netbeans"}

## -- 4.) Product Build: -- ##
ARG PRODUCT_BUILD=${PRODUCT_BUILD:-"incubating-netbeans"}

## -- 5.) Product RELEASE: -- ##
ARG PRODUCT_RELEASE=${PRODUCT_RELEASE:-"incubating-${PRODUCT_VERSION}"}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Product download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Product TAR/GZ filename: -- ##
#ARG PRODUCT_TAR=${PRODUCT_TAR:-incubating-netbeans-10.0-bin.zip}
ARG PRODUCT_TAR=${PRODUCT_TAR:-${PRODUCT_BUILD}-${PRODUCT_VERSION}-bin.zip}

## -- Product Download full URL: -- ##
ARG PRODUCT_DOWNLOAD_URL=${PRODUCT_DOWNLOAD_URL:-${PRODUCT_MIRROR_SITE_URL}/${PRODUCT_CATEGORY}/${PRODUCT_NAME}/${PRODUCT_BUILD}/${PRODUCT_RELEASE}/${PRODUCT_TAR}}

WORKDIR $HOME
RUN wget -c ${PRODUCT_DOWNLOAD_URL} && \
    unzip ${PRODUCT_TAR} && \
    sudo rm ${PRODUCT_TAR} 

#################################
#### Install Product Plugins ####
#################################
# ... add Product plugin - installation here (see example in https://github.com/DrSnowbird/papyrus-sysml-docker)
##
## -- Overcome error: Error initializing QuantumRenderer: no suitable pipeline found
##
RUN sudo apt-get install -y libswt-gtk-3-java mesa-utils libgl1-mesa-glx

##################################
#### Set up user environments ####
##################################
VOLUME ${PRODUCT_WORKSPACE}
ARG PRODUCT_PROFILE=${PRODUCT_PROFILE:-${HOME}/.${PRODUCT_NAME}}
ENV PRODUCT_PROFILE=${PRODUCT_PROFILE}
VOLUME ${PRODUCT_PROFILE}

RUN mkdir -p ${PRODUCT_PROFILE} ${PRODUCT_WORKSPACE} && \
    sudo chown -R ${USER_NAME}:${USER_NAME} ${PRODUCT_PROFILE} ${PRODUCT_WORKSPACE} 

##################################
#### --- Start up product --- ####
##################################
ENV PRODUCT_NAME=${PRODUCT_NAME:-"netbeans"}

USER ${USER_NAME}
WORKDIR ${HOME}
CMD ["/bin/sh", "-c", "${HOME}/${PRODUCT_NAME}/bin/${PRODUCT_NAME}"]
#CMD "${HOME}/${PRODUCT_NAME}/bin/${PRODUCT_NAME}"
#CMD ["/usr/bin/firefox"]
