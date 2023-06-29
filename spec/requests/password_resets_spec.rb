require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  let(:user) { create :user }

  context 'when reseting passwords' do
    describe 'password reset actions' do
      it 'new: should get new password reset entry form' do
        get '/password_resets/new'
        expect(response).to be_successful
      end

      it 'create: should send password reset email' do
        expect { post '/password_resets', params: { password_reset: { email: user.email } } }.to change {
                                                                                                   UserMailer.deliveries.size
                                                                                                 }.by(1)

        expect(response).to redirect_to '/'
      end

      it 'edit and update: should show password_reset form' do
        post '/password_resets', params: { password_reset: { email: user.email } }

        pr_email = UserMailer.deliveries.last
        pr_email_body = Capybara.string(pr_email.to_s)
        url = pr_email_body.find(:link, 'Reset Password')[:href]
        invalid_token = 'blahblahblah'
        valid_token = url.split('/')[4]
        email_section_of_url = url.split('/')[5]

        get "/password_resets/#{invalid_token}/#{email_section_of_url}"

        expect(response).to redirect_to('/')
        get "/password_resets/#{valid_token}/#{email_section_of_url}"
        expect(response).to be_successful

        new_password = 'helloworld'

        patch "/password_resets/#{invalid_token}",
              params: { email: user.email, user: { password: new_password, password_confirmation: new_password } }
        expect(response).to redirect_to('/')

        patch "/password_resets/#{valid_token}",
              params: { email: user.email, user: { password: new_password, password_confirmation: new_password } }
        expect(response).to redirect_to('/signin')
      end
    end
  end
end
