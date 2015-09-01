# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT

validation_client_name   "brewinc-validator"
validation_key           "#{current_dir}/brewinc-validator.pem"
chef_server_url          "https://192.168.34.10/organizations/brewinc"
ssl_verify_mode :verify_none
