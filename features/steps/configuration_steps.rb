Given /^I configure scube with(?: (?:in)?valid)? token (\w+)$/ do |token|
  write_file '.scube/credentials', token
end
