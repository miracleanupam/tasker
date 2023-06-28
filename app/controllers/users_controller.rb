class UsersController < ApplicationController
  def new
    redirect_to root_path if user_is_signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.activated?
        @user.update_attribute(:activated_at, Time.zone.now)
      else
        @user.create_activation_digest
        @user.send_activation_email
      end
      flash[:success] = 'Please check your email to activate your account'
      redirect_to root_path
    else
      render 'new', status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :activated)
  end
end
