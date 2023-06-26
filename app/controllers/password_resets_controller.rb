class PasswordResetsController < ApplicationController
  before_action :signed_out_user
  before_action :find_user, only: %i[create]
  before_action :check_password_validity, only: ['edit']

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_reset_email
    end
    flash[:success] = 'Check your email for further instructions'
    redirect_to root_path
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def update
    @user = User.find_by(email: params[:email])
    if @user.update(user_params)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Successfully updated the password! Please log in to continue'
      redirect_to signin_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def destroy; end

  private

  def check_password_validity
    if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
      @user.errors.add(:password, 'Cannot be empty')
      render 'edit', status: 422
    elsif params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password, 'Passwords should match')
      render 'edit', status: 422
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(email: params[:password_reset][:email])
  end

  def signed_out_user
    redirect_to root_path if user_is_signed_in?
  end
end
