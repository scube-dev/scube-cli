Given /^I configure scube with(?: (?:in)?valid)? credentials (\w+)$/ do |credentials|
  write_file '.scuberc.yaml', YAML.dump(credentials: credentials)
end
