require 'rails_helper'

RSpec.describe 'Users', type: :request do
  context 'when signing up' do
    describe 'get signup' do
      it 'should get /users/new' do
        get '/users/new'
        expect(response).to be_successful
      end
    end

    describe 'with invalid data' do
      it 'with short password' do
        user_params = { user: {
          name: 'Prison Mike',
          email: 'prison.mike@dundermifflin.com',
          password: 'foo',
          password_confirmation: 'foo'
        } }

        post '/users', params: user_params

        expect(response).not_to be_successful
        expect(response).to have_http_status(422)
      end

      it 'with mismatch passwords' do
        user_params = { user: {
          name: 'Prison Mike',
          email: 'prison.mike@dundermifflin.com',
          password: 'foo',
          password_confirmation: 'foobar'
        } }

        post '/users', params: user_params

        expect(response).not_to be_successful
        expect(response).to have_http_status(422)
      end

      it 'with already taken email' do
        email = 'already.taken@email.com'
        user = create(:user, email: email)

        user_params = { user: {
          name: 'Prison Mike',
          email: 'already.taken@email.com',
          password: 'foobar',
          password_confirmation: 'foobar'
        } }

        post '/users', params: user_params
        expect(response).not_to be_successful
        expect(response).to have_http_status(422)
      end

      it 'with valid parameters' do
        user_params = { user: {
          name: 'Prison Mike',
          email: 'new.user@gmail.com',
          password: 'foobar',
          password_confirmation: 'foobar'
        } }

        post '/users', params: user_params
        expect(response).to redirect_to('/')
      end
    end
  end
end
