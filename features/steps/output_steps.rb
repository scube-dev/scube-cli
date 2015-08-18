def build_regexp(pattern, options)
  Regexp.new(pattern, options.each_char.inject(0) do |m, e|
    m | case e
      when ?i then Regexp::IGNORECASE
      when ?m then Regexp::MULTILINE
      when ?x then Regexp::EXTENDED
    end
  end)
end


Then /^the output must contain exactly the usage$/ do
  expect(last_command_started.output).to eq <<-eoh
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

Then /^the output must match \/([^\/]+)\/([a-z]*)$/ do |pattern, options|
  expect(last_command_started.output).to match build_regexp(pattern, options)
end
