require 'rails_helper'

RSpec.feature 'CreateTasks', type: :feature do
  let(:admin_user) { create :user, admin: true }

  describe 'create task on a project' do
    before(:each) do
      visit '/'
      click_link 'Sign In'

      fill_in 'session_email', with: admin_user.email
      fill_in 'session_password', with: admin_user.password

      click_on 'Submit'
    end

    it 'create a project and perform actions on a task' do
      new_project_name = 'Danphe'
      fill_in 'project_name', with: new_project_name
      click_on 'Create'

      expect(page).to have_content('New Project Successfully Created!')
      expect(page).to have_content("#{new_project_name} | #{admin_user.name}")

      # Since as of yet, we'd only have one project
      # so there won't be multiple Add Task links
      click_link('Add Task')

      # Goes to the add task page /projects/:pid/tasks/new.task
      # Part where we fill new task form

      task_desc = 'My new task'
      fill_in 'task_description', with: task_desc
      click_on 'Submit'

      # Should redirect to root page where our task should
      # be displayed
      expect(page).to have_content("#{task_desc}to_do")

      # Since there are only one project and only one task
      # they both will have id of 1
      expect(page).to have_link('edit', href: '/projects/1/tasks/1/edit')
      expect(page).to have_link('delete', href: '/projects/1/tasks/1')

      # Edit task
      edited_desc = 'Edited Task Description'
      click_link 'edit', href: '/projects/1/tasks/1/edit'
      fill_in 'task_description', with: edited_desc
      page.select 'Completed', from: 'task_status'

      click_on 'Submit'

      # Should redirect to root path which should have edited values for the task
      expect(page).to have_content("#{edited_desc}completed")

      # Delete the task
      click_link 'delete', href: '/projects/1/tasks/1'
      expect(page).not_to have_content("#{edited_desc}completed")

      # Edit project
      edited_project_name = 'New Edited Project'
      click_link 'edit', href: '/projects/1/edit'
      fill_in 'project_name', with: edited_project_name
      click_on 'Submit'

      # On root page now
      expect(page).to have_content(edited_project_name)
      expect(page).not_to have_content(new_project_name)

      # delete the project nok
      click_link 'delete', href: '/projects/1'
      expect(page).not_to have_content(edited_project_name)
    end
  end
end
