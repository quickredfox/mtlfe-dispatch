cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8001.conf /etc/init/mtlfe-server-8001.conf && \
cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8002.conf /etc/init/mtlfe-server-8002.conf && \
cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8003.conf /etc/init/mtlfe-server-8003.conf && \
cp /var/mtlfe/dispatch/config/upstart/mtlfe-hook-9001.conf   /etc/init/mtlfe-hook-9001.conf   && \

cp /var/mtlfe/dispatch/config/monit/monitrc /etc/monit/monitrc && \
cp /var/mtlfe/dispatch/config/nginx/mtlfe.org /etc/nginx/sites-available/mtlfe.org && \


chmod 0644 /etc/monit/monitrc

rm -rf /etc/nginx/sites-enabled/mtlfe.org && \
ln -s /etc/nginx/sites-available/mtlfe.org /etc/nginx/sites-enabled/mtlfe.org && \

start mtlfe-server-8001 && \
start mtlfe-server-8002 && \
start mtlfe-server-8003 && \
start mtlfe-hook-9001

/etc/init.d/nginx restart &&\
monit -d 60 -c /etc/monit/monitrc

