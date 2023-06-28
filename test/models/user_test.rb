require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
  end

  test 'user should be valid' do
    assert @user.valid?
  end

  test 'user should have a name' do
    @user.name = ''
    assert @user.invalid? :w
  end

  test 'user should have an email' do
    @user.email = ''
    assert @user.invalid?
  end

  test 'users should have unique emails' do
    @other_user = users(:dwight)
    @other_user.email = @user.email

    assert @other_user.invalid?
  end

  test 'user email uniqueness should be case insensitive' do
    @other_user = users(:dwight)
    @other_user.email = @user.email.upcase

    assert @other_user.invalid?
  end

  test "user's email should not exceed 250 characters" do
    @user.email = 'a' * 242 + '@test.com'
    assert @user.invalid?
  end

  test 'user email should validate proper emails' do
    emails = %w[test@gmail.com test_23@hotmail.com.nz rober.california@dundermifflin.com]

    emails.each do |e|
      @user.email = e
      assert @user.valid?
    end
  end

  test 'user email should not validate improper emails' do
    improper_emails = %w[ram@gmail @yahoo.com abc.example.com abc@def@gmail.com a(sdklfd).city@gmail.com
                         just"not"right.example.com hello\world@gmai.com]

    improper_emails.each do |e|
      @user.email = e
      assert @user.invalid?
    end
  end

  test 'user email should be saved in lowercase in db' do
    mixed_case_email = 'heLLoWorld@hOTMail.COm'
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.reload.email, mixed_case_email.downcase
  end

  test 'password should have a minimum length' do
    @new_user = User.new(name: 'hello', email: 'hello@world.com', admin: false, password: 'foo',
                         password_confirmation: 'foo')
    assert @new_user.invalid?

    @new_user.password = ''
    @new_user.password_confirmation = ''

    assert @new_user.invalid?
  end
end
