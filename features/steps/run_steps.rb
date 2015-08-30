def scube_run options: nil, command: nil, check: false
  cmd = %w[scube]
  cmd << options if options
  cmd << command if command
  run_simple cmd.join(' '), false
  return unless check
  expect(last_command_started).to have_exit_status 0
rescue RSpec::Expectations::ExpectationNotMetError => e
  if ENV.key? 'SCUBE_CLI_TEST_DEBUG'
    fail RSpec::Expectations::ExpectationNotMetError, <<-eoh
#{e.message} Output was:
  ```\n#{last_command_started.output.lines.map { |l| "  #{l}" }.join}  ```
    eoh
  else
    raise
  end
end


When /^I( successfully)? run scube with options? (--?[\w-]+)$/ do |check, options|
  scube_run options: options, check: !!check
end

When /^I( successfully)? run scube with command `([^']*)'/ do |check, command|
  scube_run command: command, check: !!check
end

When /^I( successfully)? run scube with options? (--?[\w-]+) and command `([^']*)'/ do |check, options, command|
  scube_run options: options, command: command, check: !!check
end


Then /^the exit status must be (\d+)$/ do |exit_status|
  expect(last_command_started).to have_exit_status exit_status.to_i
end
