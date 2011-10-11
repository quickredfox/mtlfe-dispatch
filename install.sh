#! /bin/sh
cp config/upstart/mtlfe.conf /etc/init/mtlfe.conf &&\ 
cp config/monit/monitrc /etc/monit/monitrc &&\
cp config/nginx/mtlfe.org /etc/nginx/sites-available/mtlfe.org &&\
ln -s /etc/nginx/sites-available/mtlfe.org mtlfe.org &&\
# /etc/init.d/nginx restart &&\
# start mtlfe &&\
# monit -d 60 -c /etc/monit/monitrc &&\

