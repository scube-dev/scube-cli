def scube_run options: nil, command: nil, check: false
  cmd = %w[scube]
  cmd << options if options
  cmd << command if command
  run_simple cmd.join(' '), false
  assert_exit_status 0 if check
end


When /^I( successfully)? run scube with options? (-.+)$/ do |check, options|
  scube_run options: options, check: !!check
end

When /^I( successfully)? run scube with command `([^']*)'$/ do |check, command|
  scube_run command: command, check: !!check
end


Then /^the exit status must be (\d+)$/ do |exit_status|
  assert_exit_status exit_status.to_i
end
