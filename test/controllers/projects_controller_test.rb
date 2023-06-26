require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:toby)
    @project = projects(:streets)
    @admin_user = users(:michael)
    @non_admin_non_owner_user = users(:dwight)
  end
  test 'should redirect to signin when not signed in' do
    assert_no_difference 'Project.count' do
      post projects_path, params: { project: { name: 'The Pineapple Thief' } }
    end
    assert_redirected_to signin_path
    follow_redirect!
    assert_template 'sessions/new'

    project_copy = Marshal.load(Marshal.dump(@project))
    patch project_path(@project), params: { project: { name: 'The Pineapple Thief' } }
    assert_redirected_to signin_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_equal project_copy.name, @project.reload.name

    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
    assert_redirected_to signin_path
    follow_redirect!
    assert_template 'sessions/new'

    get edit_project_path(@project)
    assert_redirected_to signin_path
    follow_redirect!
    assert_template 'sessions/new'
  end

  test 'only admins or project owners can update/delete a project' do
    sign_user_in_from_tests(@non_admin_non_owner_user)
    project_copy = Marshal.load(Marshal.dump(@project))
    patch project_path(@project), params: { project: { name: 'The Pineapple Thief' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_equal project_copy.name, @project.reload.name

    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
    assert_redirected_to root_path
    follow_redirect!

    sign_user_in_from_tests(@admin_user)
    assert_difference 'Project.count', -1 do
      delete project_path(@project)
    end
    assert_redirected_to root_path
  end

end
