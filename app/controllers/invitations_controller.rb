class InvitationsController < ApplicationController
  def create
    user_exists_already = !!User.find_by(email: params[:invitation][:email])
    if user_exists_already
      flash[:warning] = 'Your friend already uses the app'
      redirect_to root_path
    else
      new_invite = Invitation.new
      new_invite.save
      new_invite.create_invite_digest
      new_invite.send_invite_email(params[:invitation][:email])
      flash[:success] = 'Invitation successfully sent'
      redirect_to root_path
    end
  end

  def edit
    invitee_email = params[:email]
    invite_token = params[:id]
    invite = Invitation.find_by(id: params[:invite_id])

    if invite.is_valid?(invite_token)
      @user = User.new
      @user.email = invitee_email
      @user.activated = true
      render 'users/new'
    else
      render 'shared/not_found'
    end
  end

  def destroy; end
end
