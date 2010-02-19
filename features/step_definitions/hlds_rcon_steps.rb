Given /^an instance of HLDS$/ do
  @hlds = Joystick::Source.new
end

When /^I connect to a server$/ do
  assert @hlds.connect("127.0.0.1", 27015)
end

When /^I provide some valid login information$/ do
  @hlds.auth("test")
end

Then /^the result should be a successful authentication$/ do
  @hlds.authed?
end
