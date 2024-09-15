FROM docker.io/library/ubuntu:24.04

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL
ARG HANDBRAKE=1.7.3
ARG MODULE="Tdarr_Server"

ENV \
    LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri" \
    LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

ENV WEB_UI_PORT="8265" SERVER_PORT="8266" NODE_PORT="8267" UMASK="002" TZ="Etc/UTC" HOME="/home/Tdar"

# handle deps
RUN apt-get update &&  \
        apt-get install -y \
            software-properties-common \
            git \
            wget \
            catatonit \
            curl \
            unzip \
            trash-cli && \
    mkdir -p \
    /app \
    /logs \
    /temp \
    && apt-get update && apt-get install -y curl unzip mkvtoolnix libtesseract-dev gnupg2 \
    # AMD deps
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F63F0F2B90935439 \
    && echo "deb http://ppa.launchpad.net/kisak/kisak-mesa/ubuntu noble main" > /etc/apt/sources.list.d/kisak-mesa-jammy.list \
    # Intel deps
    && echo "deb [arch=amd64] https://repositories.intel.com/gpu/ubuntu noble unified" > /etc/apt/sources.list.d/intel-graphics.list \
    && apt-key adv --fetch-keys https://repositories.intel.com/gpu/intel-graphics.key \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        intel-media-va-driver-non-free \
        intel-opencl-icd \
        vainfo \
        clinfo \
        mesa-va-drivers \
        mesa-vdpau-drivers \
        libavutil58 \
        libdrm-amdgpu1 \
        libdrm-radeon1 \
        libjansson4 \
        libspeex1 \
        libturbojpeg

RUN apt-get update \
    # FFmpeg 6 and deps
    && ffmpegversion=$(curl --silent https://api.github.com/repos/jellyfin/jellyfin-ffmpeg/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+' | sort -h | tail -n1) \
    && wget https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v$ffmpegversion/jellyfin-ffmpeg7_$ffmpegversion-noble_amd64.deb \
    && apt install -y \
        ./jellyfin-ffmpeg7_$ffmpegversion-noble_amd64.deb \
    && rm -rf ./jellyfin-ffmpeg7_$ffmpegversion-noble_amd64.deb \ 
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe

ENV BASE_LINK=https://tdarrs.s3.us-west-000.backblazeb2.com/versions

# handle tdarr binaries
RUN echo $MODULE && echo $VERSION && echo $DATE && \
    if [ "$MODULE" = "Tdarr_Node" ]; then \
        echo removing /tdarr_server && \
        rm -rdf /etc/services.d/tdarr_server ; \
    fi && \
    
    apt-get update && apt-get install -y curl unzip mkvtoolnix libtesseract-dev && \
    if uname -m | grep -q x86; then \    
        MODULE_LINK="${BASE_LINK}/${VERSION}/linux_x64/${MODULE}.zip" && \
        NODE_LINK="${BASE_LINK}/${VERSION}/linux_x64/Tdarr_Node.zip" ; \
    fi && \
    if uname -m | grep -q aarch64; then \
        MODULE_LINK="${BASE_LINK}/${VERSION}/linux_arm64/${MODULE}.zip" && \
        NODE_LINK="${BASE_LINK}/${VERSION}/linux_arm64/Tdarr_Node.zip" ; \
    fi && \
    if uname -m | grep -q armv7l; then \
        MODULE_LINK="${BASE_LINK}/${VERSION}/linux_arm/${MODULE}.zip" && \
        NODE_LINK="${BASE_LINK}/${VERSION}/linux_arm/Tdarr_Node.zip" ; \
    fi && \

    echo MODULE_LINK=$MODULE_LINK && \
    echo NODE_Link=$NODE_LINK && \
    curl --connect-timeout 120 --retry 5 -o /tmp/$MODULE.zip -L \
    "$MODULE_LINK"  && \
    unzip -q /tmp/$MODULE.zip -d /app/$MODULE -x *.exe && \
    if [ "$MODULE" = "Tdarr_Server" ]; then \
        curl --connect-timeout 120 --retry 5 -o /tmp/Tdarr_Node.zip -L \
        "$NODE_LINK" && \
        unzip -q /tmp/Tdarr_Node.zip -d /app/Tdarr_Node -x *.exe ; \
    fi && \
    rm -rdf /tmp/$MODULE.zip && \
    rm -rdf /tmp/Tdarr_Node.zip && \

    cp -r /app /app_test && \
    runTests=true runDockerTests=true /app_test/$MODULE/$MODULE && \
    if [ "$MODULE" = "Tdarr_Server" ]; then \
           runTests=true runDockerTests=true /app_test/Tdarr_Node/Tdarr_Node ; \
    fi && \
    rm -rdf /app_test && \

    trash-empty && \
    apt-get autoremove -y

RUN chown -R nobody:nogroup /app \
    && chmod a+rwx -R /app/Tdarr_Node/assets/app/ffmpeg/

USER nobody:nogroup

COPY ./apps/tdarr/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

EXPOSE ${NODE_PORT}
EXPOSE ${WEB_UI_PORT}
EXPOSE ${SERVER_PORT}
