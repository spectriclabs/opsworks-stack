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


%w[ /opt/nomad /opt/nomad/etc /opt/nomad/etc/server /opt/nomad/bin ].each do |path|
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

cookbook_file '/opt/nomad/etc/server/configuration.hcl' do
    source 'nomad_server.configuration.hcl'
    owner 'nomad'
    group 'nomad'
    mode '0755'
    action :create
end

cookbook_file '/etc/systemd/system/nomad-server.service' do
    source 'nomad-server.service'
    owner 'nomad'
    group 'nomad'
    mode '0755'
    action :create
end

execute 'enable nomad-server' do
    command 'systemctl enable nomad-server'
end

execute 'enable nomad-server' do
    command 'systemctl restart nomad-server'
end