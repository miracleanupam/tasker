module SessionsHelper
  def sign_user_in(user)
    session[:user_id] = user.id
  end

  def sign_user_out
    session.delete(:user_id)
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def current_user?(user)
    current_user == user
  end

  def user_is_signed_in?
    !current_user.nil?
  end
end
