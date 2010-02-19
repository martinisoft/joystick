$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'joystick'

require 'spec/expectations'
require 'test/unit/assertions'

World do
  include Test::Unit::Assertions
end
