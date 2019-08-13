group "consul" do
    system true
end

user "consul" do
    home "/var/lib/consul"
    shell "/bin/bash"
    group "consul"
    system true  
end

directory "/var/lib/consul" do
    group "consul"
    owner "consul"
    mode "0755"
end


%w[ /opt/consul /opt/consul/etc /opt/consul/etc/server /opt/consul/bin ].each do |path|
    directory path do
        group "consul"
        owner "consul"
        mode "0755"
    end
end

execute 'install unzip' do
    command 'apt install unzip'
end

script 'extract_module' do
    interpreter "bash"
    cwd "/tmp"
    code <<-EOH
      wget https://releases.hashicorp.com/consul/1.5.3/consul_1.5.3_linux_amd64.zip
      cd /opt/consul/bin
      unzip /tmp/consul_1.5.3_linux_amd64.zip
      rm /tmp/consul_1.5.3_linux_amd64.zip
      EOH
end

cookbook_file '/opt/consul/etc/server/configuration.hcl' do
    source 'consul_server.configuration.hcl'
    owner 'consul'
    group 'consul'
    mode '0755'
    action :create
end

cookbook_file '/etc/systemd/system/consul-server.service' do
    source 'consul-server.service'
    owner 'consul'
    group 'consul'
    mode '0755'
    action :create
end

execute 'enable consul-server' do
    command 'systemctl enable consul-server'
end

execute 'enable consul-server' do
    command 'systemctl restart consul-server'
end