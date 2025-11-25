FROM scratch as build
ADD root.gz /
USER root 
RUN rm -f /swapfile
RUN cp -rp /root/.bashrc /root/oldbashrc && head -13 /root/.bashrc > /root/.bashrc
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

FROM scratch
USER root 
COPY --from=build / /
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sh", "-c", "sleep infinity"]
