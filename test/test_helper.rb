ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  def sign_user_in_from_tests(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def sign_user_in_from_tests(user, password: 'password')
    post signin_path params: {
      session: {
        email: user.email,
        password: password
      }
    }
  end
end
