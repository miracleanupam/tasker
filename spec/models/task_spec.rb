require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create :user }
  let(:project) { create :project, user: user }
  let(:task) { build :task, project: project }

  def create_tasks_for_project(proj, count: 5)
    create_list(:task, count, project: proj)
  end

  def create_projects_and_tasks_for_user(usr, project_count: 5, tasks_in_each_project: 5)
    create_list(:project, project_count, user: usr) do |proj|
      create_tasks_for_project(proj, count: tasks_in_each_project)
    end
  end

  context 'when creating a task' do
    describe 'validations' do
      it 'should be valid' do
        expect(task.valid?).to be true
      end

      it 'should have a description' do
        task.description = nil
        expect(task.valid?).to be false
      end

      it 'should have a status of to_do by default' do
        task_wo_status = Task.create(description: 'This is a task without specifying a status')
        task_wo_status.save
        expect(task_wo_status.status).to eq('to_do')
      end

      it 'should be associated with a project' do
        task.project = nil
        expect(task.valid?).to be false
      end

      it 'status should not contain anything other than to_do, ongoing, completed, failed, or rejected' do
        task.status = 'to_do'
        expect(task.valid?).to be true

        task.status = 'ongoing'
        expect(task.valid?).to be true

        task.status = 'completed'
        expect(task.valid?).to be true

        task.status = 'failed'
        expect(task.valid?).to be true

        task.status = 'rejected'
        expect(task.valid?).to be true

        
        expect { task.status = 'something_invalid' }.to raise_error(ArgumentError)
      end
    end

    describe 'associations' do
      it 'deletion of project should delete associated tasks' do
        project_tasks = create_tasks_for_project(project)
        expect { project.destroy }.to change { Task.count }.by(-1 * project.tasks.count).and change {
                                                                                               Project.count
                                                                                             }.by(-1)
      end

      it 'deletion of user who owns the project should delete his projects as well as tasks' do
        create_projects_and_tasks_for_user(user)

        total_tasks_count = 0
        user.projects.each do |p|
          total_tasks_count += p.tasks.count
        end

        expect { user.destroy }.to change { User.count }.by(-1).and change {
                                                                      Project.count
                                                                    }.by(-1 * user.projects.count).and change {
                                                                                                         Task.count
                                                                                                       }.by(-1 * total_tasks_count)
      end
    end
  end
end
