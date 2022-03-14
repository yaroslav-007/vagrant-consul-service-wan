#!/usr/bin/env bash
#!/usr/bin/env bash
set -x 

apt-get update
apt-get upgrade -y 
apt-get update

apt-get install \
    apt-transport-https \
    gnupg-agent \
    tree \
    jq \
    unzip -y


####CONSUL
####Install consul

consul_version=`curl  -s https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | egrep -v 'ent|beta|rc|alpha|connect' | sort -V | tail -n 1`




wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -O /tmp/consul.zip
unzip /tmp/consul.zip -d /tmp
mv /tmp/consul /usr/local/bin
rm -f /tmp/consul.zip


echo "complete -C /usr/local/bin/consul consul" >> /home/vagrant/.bashrc

useradd --system --home /etc/consul.d --shell /bin/false consul
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul
###Consul server configuration
mkdir -p /etc/consul.d

cat <<EOF > /etc/consul.d/server.hcl
datacenter = "$3"
data_dir = "/opt/consul"
server = true
bootstrap_expect = 1
retry_join = [ "$1"]
retry_join_wan = [ "$1" , "$2"]
ui_config {
  enabled = true
}
bind_addr = "{{ GetInterfaceIP \"enp0s8\" }}"
client_addr = "0.0.0.0"

connect {
  enabled = true
}

ports {
  http = 8500
  grpc = 8502
}
EOF


chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/server.hcl

####Configure systemd

touch /etc/systemd/system/consul.service
cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/server.hcl
[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s HUP \$MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now consul
