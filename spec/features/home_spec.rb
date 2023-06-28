require 'rails_helper'

RSpec.feature 'Homes', type: :feature do
  let(:user) { create :user, password: 'foobar', password_confirmation: 'foobar' }
  let(:admin_user) { create :user, password: 'foobar', password_confirmation: 'foobar', admin: true }

  context 'some context' do
    describe 'home page without signing in' do
      it 'should have brank link, signin and signup links' do
        visit '/'
        expect(page).to have_link('TASKER')
        expect(page).to have_link('Sign In')
        expect(page).to have_link('Sign Up!')
      end

      it 'test signin' do
        visit '/'
        click_link 'Sign In'

        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password

        click_on 'Submit'
        expect(page).to have_content('Here are your Project-wise tasks:')
        expect(page).to have_link('Sign Out')
      end

      it 'test signup' do
        visit '/'
        click_link 'Sign Up!'

        fill_in 'user_name', with: 'Bojack Horseman'
        fill_in 'user_email', with: 'bojack@horseman.com'
        fill_in 'user_password', with: 'foobar'
        fill_in 'user_password_confirmation', with: 'foobar'

        click_on 'Submit'

        expect(page).to have_content('Please check your email to activate your account')
      end
    end
  end

  context 'home as admin' do
    before(:each) do
      visit '/'
      click_link 'Sign In'

      fill_in 'session_email', with: admin_user.email
      fill_in 'session_password', with: admin_user.password

      click_on 'Submit'
    end
    describe 'home page as admin' do
      it 'should have a section to invite other users to the platform' do
        visit '/'

        fill_in 'invitation_email', with: 'tester@home.com'
        click_on 'Invite'
        expect(page).to have_content('Invitation successfully sent')
      end

      it 'should have projects from all users in project_name | owner format' do
        user_project = create :project, user: user
        admin_user_project = create :project, user: admin_user

        visit '/'

        expect(page).to have_content("#{user_project.name} | #{user.name}")
        expect(page).to have_content("#{admin_user_project.name} | #{admin_user.name}")

        expect(page).to have_link('edit', href: "/projects/#{user_project.id}/edit")
        expect(page).to have_link('delete', href: "/projects/#{user_project.id}")
        expect(page).to have_link('Add Task', href: "/projects/#{user_project.id}/tasks/new.task")
      end
    end
  end
end
