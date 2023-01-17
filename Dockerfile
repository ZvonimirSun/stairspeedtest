FROM alpine as tools
WORKDIR /tool
RUN apk update && apk add wget && \
    wget https://github.com/tindy2013/stairspeedtest-reborn/releases/download/v0.7.1/stairspeedtest_reborn_linux64.tar.gz -O 071.tar.gz && \
    mkdir -p 070 && \
    tar xf 071.tar.gz -C 071 && \
    mv -f 071/stairspeedtest/stairspeedtest . && \
    rm -rf 071 071.tar.gz && \
    mv tools/gui/gui.html tools/gui/index.html

FROM alpine
LABEL Auther="tindy2013" \
      Source="https://github.com/tindy2013/stairspeedtest-reborn" \
      Builder="ZvonimirSun"
WORKDIR /speedtest
COPY --from=tools /tool .
RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    chmod -R +x *.sh
EXPOSE 65430
VOLUME ["/speedtest/results"]
ENTRYPOINT ["./webgui.sh"]