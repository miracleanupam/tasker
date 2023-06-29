class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    if @user&.authenticated?("activation", params[:id])
      if @user.activated? && !user_is_signed_in?
        flash[:warning] = 'Already activated, please signin'
        redirect_to signin_path
      elsif @user.activated?
        flash[:warning] = 'Already activated'
        redirect_to root_path
      else
        @user.activate
        flash[:warning] = 'Successfully activated'
        redirect_to signin_path
      end
    else
      flash[:danger] = 'Something went wrong'
      redirect_to root_path
    end
  end
end
