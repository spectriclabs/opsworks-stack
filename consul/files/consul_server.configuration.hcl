datacenter = "dc1"
data_dir = "/var/lib/consul"
retry_join = [ "provider=aws tag_key=role tag_value=consul-server" ]
server = true
bootstrap_expect = 3
ui = true