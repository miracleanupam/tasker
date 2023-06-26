require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:toby)
    @project = projects(:mountains)
    @task = tasks(:mountains_task_one)

    @other_project = projects(:photo_home)
    @admin_user = users(:michael)
    @non_admin_non_owner_user = users(:dwight)
  end

  test 'should redirect to signin when not signed in' do
    get new_project_task_path(@project)
    assert_redirected_to signin_path

    assert_no_difference 'Task.count' do
      post project_tasks_path(@project), params: { task: { description: 'new task', status: 'to_do' } }
    end
    assert_redirected_to signin_path

    get edit_project_task_path(@project, @task)
    assert_redirected_to signin_path

    get edit_project_task_path(@project, @task)
    assert_redirected_to signin_path

    task_copy = Marshal.load(Marshal.dump(@task))
    patch project_task_path(@project, @task), params: { task: { description: 'hello hello hello', status: 'rejected' } }
    @task.reload
    assert_equal task_copy.description, @task.description
    assert_equal task_copy.status, @task.status
    assert_redirected_to signin_path

    assert_no_difference 'Task.count' do
      delete project_task_path(@project, @task)
    end
    assert_redirected_to signin_path
  end

  test 'task action cannot be performed by non-admin non-owners' do
    # tests with wrong owner, shouldn't be able to do anything
    sign_user_in_from_tests(@non_admin_non_owner_user)

    get new_project_task_path(@project)
    assert_redirected_to root_path

    assert_no_difference 'Task.count' do
      post project_tasks_path(@project),
           params: { task: { description: "dwight tried to add task in toby's project", status: 'to_do' } }
    end
    assert_redirected_to root_path

    get edit_project_task_path(@project, @task)
    assert_redirected_to root_path

    task_copy = Marshal.load(Marshal.dump(@task))
    patch project_task_path(@project, @task), params: { task: { description: 'hello hello hello', status: 'rejected' } }
    @task.reload
    assert_equal task_copy.description, @task.description
    assert_equal task_copy.status, @task.status
    assert_redirected_to root_path

    assert_no_difference 'Task.count' do
      delete project_task_path(@project, @task)
    end
    assert_redirected_to root_path
  end

  test 'task action can be performed by admin users' do
    sign_user_in_from_tests(@admin_user)

    get new_project_task_path(@project)
    assert_template 'tasks/new'

    assert_difference 'Task.count', 1 do
      post project_tasks_path(@project),
           params: { task: { description: "dwight tried to add task in toby's project", status: 'to_do' } }
    end
    assert_redirected_to root_path

    get edit_project_task_path(@project, @task)
    assert_template 'tasks/edit'

    task_copy = Marshal.load(Marshal.dump(@task))
    patch project_task_path(@project, @task), params: { task: { description: 'hello hello hello', status: 'rejected' } }
    @task.reload
    assert_equal 'hello hello hello', @task.description
    assert_equal 'rejected', @task.status
    assert_redirected_to root_path

    assert_difference 'Task.count', -1 do
      delete project_task_path(@project, @task)
    end
    assert_redirected_to root_path
  end

  test 'should not be able to perform :edit, :update, :destroy actions when the task and projects, do not match' do
    sign_user_in_from_tests(@admin_user)

    get edit_project_task_path(@other_project, @task)
    assert_redirected_to root_path

    task_copy = Marshal.load(Marshal.dump(@task))
    patch project_task_path(@other_project, @task),
          params: { task: { description: 'hello hello hello', status: 'rejected' } }
    @task.reload
    assert_equal task_copy.description, @task.description
    assert_equal task_copy.status, @task.status
    assert_redirected_to root_path

    assert_no_difference 'Task.count' do
      delete project_task_path(@other_project, @task)
    end
    assert_redirected_to root_path
  end
end
