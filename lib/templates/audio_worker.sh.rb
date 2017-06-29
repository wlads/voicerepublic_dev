#!/bin/bash

CLIENT_TOKEN=<%= client_token %>
ENDPOINT=<%= instance_endpoint %>
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

AWS_CREDENTIALS=<%= aws_credentials %>
echo $AWS_CREDENTIALS > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

# report ready
JSON='{"instance":{"public_ip_address":"'$PUBLIC_IP'","event":"complete"}}'
COMMAND="curl -X PUT --data $JSON $CALLBACK_URL/$CLIENT_TOKEN"
N=0
until [ $N -ge 10 ]
do
    $COMMAND && break
    N=$[$N+1]
    echo `date` "failed to report ready, retry $N" >> ~/actions.log
done

# run
su -c 'INSTANCE=<%= client_token %> ENDPOINT=<%= queue_endpoint %> ruby /home/admin/audio_worker/runner.rb' admin

# report terminate
JSON='{"instance":{"public_ip_address":"'$PUBLIC_IP'","event":"terminate"}}'
COMMAND="curl -X PUT --data $JSON $CALLBACK_URL/$CLIENT_TOKEN"
N=0
until [ $N -ge 10 ]
do
    $COMMAND && break
    N=$[$N+1]
    echo `date` "failed to report ready, retry $N" >> ~/actions.log
done

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
shutdown -h now
