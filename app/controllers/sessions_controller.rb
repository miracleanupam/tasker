class SessionsController < ApplicationController
  def new
    return unless user_is_signed_in?

    redirect_to root_path
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      sign_user_in(@user)
      redirect_to root_path
    else
      flash[:danger] = 'Invalid Credentials'
      render 'new', status: 422
    end
  end

  def destroy
    sign_user_out if user_is_signed_in?
    redirect_to root_path
  end
end
