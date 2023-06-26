require "test_helper"

class ProjectsPageTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:michael)
    @user = users(:toby)
    @project = projects(:streets)
  end

  test 'projects index with admin user' do
    sign_user_in_from_tests(@admin_user)
    get projects_path
    assert_template 'projects/index'

    first_project = @admin_user.project_feed.first

    # There should a invitation input 
    assert_select 'input#invitation_email'

    # There should be a input for creating new project
    assert_select 'input#project_name'

    # There should be a card class for projects display
    assert_select 'div.card'
    assert_select 'div.card-header'
    assert_select 'div.card-body'
    assert_select 'div.card-footer'
    assert_select 'a[href=?]', new_project_task_path(first_project, :task), text: 'Add Task'

    assert_select "select#filter_#{first_project.id}"
    assert_select "input#search_#{first_project.id}"
  end

  test 'filter and search functionality' do
    sign_user_in_from_tests(@user)
    project_id = @project.id

    # Pagination
    get projects_path
    assert_select "div##{@project.id}" do
      assert_select 'nav>ul.pagination'
    end

    # Filter
    statuses = %w[to_do ongoing completed failed rejected]
    statuses.each do |status|
      statuses_that_should_have_zero_tasks = statuses.reject { |st| st == status }
      get projects_path, params: { "filter_#{project_id}": status }
      assert_select "div##{@project.id}" do
        statuses_that_should_have_zero_tasks.each do |szt|
          assert_select 'div.card-text>span.lefter>span', text: szt, count: 0
        end
      end
    end

    # Search
    search_term = 'interview'
    get projects_path, params: { "search_#{project_id}": search_term }
    assert_select "div##{@project.id}" do
      assert_select 'span.task-desc' do |task_descriptions|
        task_descriptions.each do |td|
          assert_match search_term.downcase, td.text.downcase
        end
      end
    end
  end
end
