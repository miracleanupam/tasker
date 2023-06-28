module SpecTestHelper
  def sign_user_in_from_test(user, password: 'password')
    session[:user_id] = user.id
  end
end
