require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = projects(:shabdakosh)
    @user = users(:michael)
  end

  test 'project should be valid' do
    assert @project.valid?
  end

  test 'project should have a name but not exceeding 100 characters' do
    @project.name = ''
    assert @project.invalid?

    @project.name = 'a' * 101
    assert @project.invalid?
  end

  test 'project should belong to a user' do
    @project.user = nil
    assert @project.invalid?
  end

  test "deletion of project's owner should delete the project too" do
    assert_difference 'Project.count', -1 * @user.projects.count do
      @user.destroy
    end
  end
end
