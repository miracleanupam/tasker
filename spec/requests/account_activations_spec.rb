require 'rails_helper'

RSpec.describe 'AccountActivations', type: :request do
  context 'account activation' do
    it 'create a user and activate the account' do
      user_params = { user: { name: 'John Doe', email: 'johndoe@gmail.com', password: 'foobar',
                              password_confirmation: 'foobar' } }

      expect { post '/users', params: user_params }.to change { UserMailer.deliveries.size }.by(1)

      ae = UserMailer.deliveries.last
      ae_string = Capybara.string(ae.to_s)
      url = ae_string.find(:link, 'Activate')[:href]
      email_section_of_url = url.split('/')[5]
      invalid_token = 'blahblahblah'
      valid_token = url.split('/')[4]

      get "/account_activations/#{invalid_token}/#{email_section_of_url}"
      expect(response).to redirect_to('/')

      get "/account_activations/#{valid_token}/#{email_section_of_url}"
      expect(response).to redirect_to('/signin')
    end
  end
end
