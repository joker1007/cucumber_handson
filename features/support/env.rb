ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])

require 'capybara'
require 'capybara/cucumber'

require File.dirname(__FILE__) + '/../../vending_machine'
require File.dirname(__FILE__) + '/../../app'

Capybara.app = VendingMachineApp.new

class VendingMachineAppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  VendingMachineAppWorld.new
end
