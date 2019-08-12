include_recipe 'ark'

ark 'nomad' do
    url 'https://releases.hashicorp.com/nomad/0.9.4/nomad_0.9.4_linux_amd64.zip'
    #checksum
    #version
    #strip_components 0
    #prefix_bin '/opt/nomad
    #has_binaries %w(nomad)
    #action :install
end
