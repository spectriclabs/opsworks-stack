data_dir = "/var/lib/nomad/server"

bind_addr = "0.0.0.0"

server {
    enabled = true
    bootstrap_expect = 3
    server_join {
        retry_join = [ "provider=aws tag_key=role tag_value=nomad-server" ]
    }
}