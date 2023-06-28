require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when creating a user' do
    let(:user) { build :user }
    let(:another_user) { build :user, email: user.email }

    it 'should be valid' do
      expect(user.valid?).to be true
    end

    it 'should have a name' do
      user.name = nil
      expect(user.valid?).to be false
    end

    it 'should have an email' do
      user.email = nil
      expect(user.valid?).to be false
    end

    it 'should hlve unique emails' do
      user.save
      expect(another_user.valid?).to be false
    end

    it 'should have case insensitive emails' do
      user.save
      another_user.email = another_user.email.upcase
      expect(another_user.valid?).to be false
    end

    it 'email should not exceed 250 characters' do
      user.email = "#{'a' * 242}@test.com"
      expect(user.valid?).to be false
    end

    it 'should validate proper emails' do
      emails = %w[test@gmail.com test_23@hotmail.com.nz rober.california@dundermifflin.com]
      emails.each do |e|
        user.email = e
        expect(user.valid?).to be true
      end
    end

    it 'should not validate improper emails' do
      improper_emails = %w[ram@gmail @yahoo.com abc.example.com abc@def@gmail.com a(sdklfd).city@gmail.com
                           just"not"right.example.com hello\world@gmai.com]
      improper_emails.each do |e|
        user.email = e
        expect(user.valid?).to be false
      end
    end

    it 'should save user emails in lowercase in db' do
      mixed_case_email = 'hELLoWorld@Test.CoM'
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end

    it 'password should have a minimum length of 6' do
      user.password = 'foo'
      user.password_confirmation = 'foo'
      expect(user.valid?).to be false

      user.password = ''
      user.password_confirmation = ''
      expect(user.valid?).to be false
    end
  end
end
