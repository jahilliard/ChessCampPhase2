require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'contexts'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include Contexts

  # Add more helper methods to be used by all tests here...
  	def deny(condition)
		# a simple transformation to increase readability IMO
		assert !condition
	end
end
# Formatting test output a litte nicer
Turn.config.format = :outline