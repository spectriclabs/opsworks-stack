group "nomad" do
    system true
end

user "nomad" do
    home "/var/lib/nomad"
    shell "/bin/bash"
    group "nomad"
    system true  
end

directory "/var/lib/nomad" do
    group "nomad"
    owner "nomad"
    mode "0755"
end


%w[ /opt/nomad /opt/nomad/etc /opt/nomad/etc/client /opt/nomad/bin ].each do |path|
    directory path do
        group "nomad"
        owner "nomad"
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
      wget https://releases.hashicorp.com/nomad/0.9.4/nomad_0.9.4_linux_amd64.zip
      cd /opt/nomad/bin
      unzip /tmp/nomad_0.9.4_linux_amd64.zip
      rm /tmp/nomad_0.9.4_linux_amd64.zip
      EOH
end

cookbook_file '/opt/nomad/etc/client/configuration.hcl' do
    source 'nomad_client.configuration.hcl'
    owner 'nomad'
    group 'nomad'
    mode '0755'
    action :create
end

cookbook_file '/etc/systemd/system/nomad-client.service' do
    source 'nomad-client.service'
    owner 'nomad'
    group 'nomad'
    mode '0755'
    action :create
end


script 'setup_docker' do
    interpreter "bash"
    cwd "/tmp"
    code <<-EOH
        apt-get -y update
        apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"
        apt-get -y update
        apt-get -y install docker-ce docker-ce-cli containerd.io
      EOH
end

group "docker" do
    append true
    members 'nomad'
    action :modify
end

execute 'enable docker' do
    command 'systemctl enable docker'
end

execute 'restart docker' do
    command 'systemctl restart docker'
end

execute 'enable nomad-client' do
    command 'systemctl enable nomad-client'
end

execute 'restart nomad-server' do
    command 'systemctl restart nomad-client'
end