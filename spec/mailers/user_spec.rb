require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :user }

  describe 'password reset' do
    it 'has proper parameters' do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq('Password Reset on Tasker')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@tasker.com'])

      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))

      expect { mail.deliver }.to change { UserMailer.deliveries.size }.by(1)
    end
  end

  describe 'invitation' do
    it 'has proper parameters' do
      new_email = 'new.user@example.com'
      invite = Invitation.new
      invite.save
      invite.create_invite_digest
      mail = UserMailer.invitation(invite, new_email)

      expect(mail.subject).to eq('Invitation to use Tasker')
      expect(mail.to).to eq([new_email])
      expect(mail.from).to eq(['noreply@tasker.com'])

      expect(mail.body.encoded).to match(invite.invite_token)
      expect(mail.body.encoded).to match(CGI.escape(new_email))

      expect { mail.deliver }.to change { UserMailer.deliveries.size }.by(1)
    end
  end

  describe 'account activations' do
    it 'has proper parameters' do
      user.activation_token = User.new_token
      mail = UserMailer.activation(user)
      expect(mail.subject).to eq('Activate Tasker Account')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@tasker.com'])

      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))

      expect { mail.deliver }.to change { UserMailer.deliveries.size }.by(1)
    end
  end
end
