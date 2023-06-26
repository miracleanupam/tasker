require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.activation(user)
    assert_equal 'Activate Tasker Account', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@tasker.com'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test 'password_reset' do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'Password Reset on Tasker', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@tasker.com'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test 'invitation' do
    new_email = 'new.user@example.com'
    invite = Invitation.new
    invite.save
    invite.create_invite_digest
    mail = UserMailer.invitation(invite, new_email)
    assert_equal [new_email], mail.to
    assert_equal ['noreply@tasker.com'], mail.from
    assert_match invite.invite_token, mail.body.encoded
    assert_match CGI.escape(new_email), mail.body.encoded
  end
end
