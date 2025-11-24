FROM scratch as build
ADD root.gz /
RUN rm -f /swapfile
RUN head -13 /root/.bashrc > /root/.bashrc

RUN echo "tail -f /entrypoint.sh" > /entrypoint.sh

FROM scratch
COPY --from=build / /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
