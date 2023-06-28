require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { create :user }
  let(:project) { create :project, user: user }
  let(:task) { create :task, project: project }

  context 'doing stuff with tasks' do
    describe 'without signing in' do
      it 'should redirect to root path' do
        get "/projects/#{project.id}/tasks/new"
        expect(response).to redirect_to('/signin')

        post "/projects/#{project.id}/tasks"
        expect(response).to redirect_to('/signin')

        get "/projects/#{project.id}/tasks/#{task.id}/edit"
        expect(response).to redirect_to('/signin')

        patch "/projects/#{project.id}/tasks/#{task.id}"
        expect(response).to redirect_to('/signin')

        delete "/projects/#{project.id}/tasks/#{task.id}"
        expect(response).to redirect_to('/signin')
      end
    end
  end

  context 'after signing in' do
    before(:each) do
      post signin_path params: { session: { email: user.email, password: user.password } }
    end

    describe 'with invalid data' do
      it 'creating a task' do
        params = {
          project_id: project.id,
          task: {
            description: nil,
            status: 'to_do'
          }
        }

        post "/projects/#{project.id}/tasks", params: params
        expect(response).to have_http_status(422)
      end

      it 'updating a task' do
        params = {
          project_id: project.id,
          task: {
            description: nil,
            status: 'completed'
          }
        }

        patch "/projects/#{project.id}/tasks/#{task.id}", params: params
        expect(response).to have_http_status(422)
      end
    end

    describe 'new edit and destory' do
      it 'should get new task response' do
        get "/projects/#{project.id}/tasks/new"
        expect(response).to be_successful
      end

      it 'should get edit task reponse' do
        get "/projects/#{project.id}/tasks/#{task.id}/edit"
        expect(response).to be_successful
      end

      it 'delete a task' do
        delete "/projects/#{project.id}/tasks/#{task.id}"
        expect(response).to redirect_to('/')
      end
    end
  end
end
