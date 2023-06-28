require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @task = tasks(:medical_one)
  end

  test 'task should be valid' do
    assert @task.valid?
  end

  test 'task should have an description' do
    @task.description = nil
    assert @task.invalid?
  end

  test 'task should have an status of to_do by default' do
    project = projects(:medical_notes)
    @new_task = Task.create(description: 'This is a task for testing', project: project)

    assert_equal @new_task.status, 'to_do'
  end

  test 'task should be associated to a project' do
    @task.project = nil
    assert @task.invalid?
  end

  test 'deletion of the project should delete the task associated with it' do
    project = projects(:medical_notes)

    assert_difference 'Task.count', -1 * project.tasks.count do
      project.destroy
    end
  end

  test 'task status should not contain anything else other than to_do, ongoing, completed, failed, or rejected' do
    @task.status = 'to_do'
    assert @task.valid?

    @task.status = 'ongoing'
    assert @task.valid?

    @task.status = 'completed'
    assert @task.valid?

    @task.status = 'failed'
    assert @task.valid?

    @task.status = 'rejected'
    assert @task.valid?

    assert_raises(ArgumentError) do
      @task.status = 'invalid_status'
    end
  end

  test 'deletion of the project owner of project, a task belongs to, should delete the tasks of that user too' do
    user = users(:michael)

    total_tasks_of_michael = 0
    user.projects.each do |p|
      total_tasks_of_michael += p.tasks.count
    end
    assert_difference 'Task.count', -1 * total_tasks_of_michael do
      user.destroy
    end
  end
end
