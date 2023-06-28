require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create :user }
  let(:project) { create :project, user: user }

  context 'doing stuff with projects' do
    describe 'without singing in' do
      it 'should redirect to signin path' do
        get '/projects'
        expect(response).to redirect_to('/signin')

        post '/projects'
        expect(response).to redirect_to('/signin')

        patch "/projects/#{project.id}"
        expect(response).to redirect_to('/signin')

        delete "/projects/#{project.id}"
        expect(response).to redirect_to('/signin')
      end
    end
  end

  context 'after signin in' do
    # before(:each) do
    #    sign_user_in_from_test(user)
    # end

    before(:each) do
      post signin_path params: { session: { email: user.email, password: user.password } }
    end

    describe 'with invalid data' do
      it 'creating project' do
        project_params = {
          project: {
            name: nil
          }
        }

        post '/projects', params: project_params
        expect(response).to have_http_status(204)
      end

      it 'updating project' do
        project_params = {
          project: {
            name: nil
          }
        }

        patch "/projects/#{project.id}", params: project_params
        expect(response).to have_http_status(422)
      end
    end

    describe 'with valid data' do
      it 'creating project' do
        project_params = {
          project: {
            name: 'New Project'
          }
        }

        post '/projects', params: project_params
        expect(response).to redirect_to('/')
      end

      it 'updating project' do
        project_params = {
          project: {
            name: 'Edited Project Name'
          }
        }

        patch "/projects/#{project.id}", params: project_params
        expect(response).to redirect_to('/')
      end
    end

    describe 'index and delete' do
      it 'delete project' do
        delete "/projects/#{project.id}"
        expect(response).to redirect_to('/')
      end

      it 'index of projects' do
        get '/projects'
        expect(response).to be_successful
      end
    end
  end
end
