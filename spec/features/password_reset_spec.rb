require 'rails_helper'

RSpec.feature 'PasswordResets', type: :feature do
  let(:user) { create :user }
  describe 'process of resetting password' do
    it 'forgot password' do
      visit '/signin'

      click_on 'Forgot Password?'

      # Enter email on the new page
      fill_in 'password_reset_email', with: user.email

      click_on 'Submit'

      expect(page).to have_content('Check your email for further instructions')
      pr_email = UserMailer.deliveries.last
      email_page = Capybara.string(pr_email.to_s)

      url = email_page.find(:link, 'Reset Password')[:href]
      visit url

      expect(page).to have_content('Reset Your Password')
      new_password = 'newpassword'
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      click_on 'Update Password'

      expect(page).to have_content('Successfully updated the password! Please log in to continue')
      expect(page).to have_content('Sign In')
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: new_password

      click_on 'Submit'

      expect(page).to have_content('Here are your Project-wise tasks:')
    end
  end
end
