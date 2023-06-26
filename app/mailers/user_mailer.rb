class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.invitation.subject
  #
  def invitation(invitation, invitee)
    @invitation = invitation
    @invitee = invitee
    @greeting = 'Hi'

    mail to: @invitee, subject: 'Invitation to use Tasker'
  end

  def password_reset(user)
    @greeting = 'Hi'
    @user = user

    mail to: @user.email, subject: 'Password Reset on Tasker'
  end

  def activation(user)
    @greeting = 'Hi'
    @user = user

    mail to: @user.email, subject: 'Activate Tasker Account'
  end
end
