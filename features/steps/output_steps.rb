Then /^the output must contain exactly the usage$/ do
  expect(all_output).to eq <<-eoh
Usage: scube [options] command

options:
    -v, --verbose                    enable verbose mode
    -h, --help                       print this message
    -V, --version                    print version

commands:
  import   Import local sound file into scube
  ping     Ping scube server
  ping:auth Ping scube server (authenticated)
  signin   Signin and get authentication token
  eoh
end
