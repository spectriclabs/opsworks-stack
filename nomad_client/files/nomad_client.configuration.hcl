data_dir = "/var/lib/nomad/client"

bind_addr = "0.0.0.0"

client {
    enabled = true
    
    server_join {
        retry_join = [ "provider=aws tag_key=role tag_value=nomad-server" ]
    }
    
}