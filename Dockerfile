FROM scratch as build
ADD root.gz /
USER root 
RUN rm -f /swapfile
RUN head -13 /root/.bashrc > /root/.bashrc
ADD fix-hosts.sh /usr/local/bin/fix-hosts.sh
RUN chmod +x /usr/local/bin/fix-hosts.sh

FROM scratch
USER root 
COPY --from=build / /
ENTRYPOINT ["/usr/local/bin/fix-hosts.sh"]
CMD ["sh", "-c", "sleep infinity"]
