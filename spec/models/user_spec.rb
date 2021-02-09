require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new({
                       first_name: 'First Name',
                       last_name: 'Last Name',
                       email: 'email',
                       password: '1234',
                       password_confirmation: '1234'
                     })
  end

  describe 'Validations' do
    context 'with all valid attributes' do
      it 'validates succesfully' do
        expect(@user).to be_valid
      end
    end
    context 'Passwords' do
      it 'is not valid without a password' do
        @user.password = nil
        @user.save
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'is not valid when passwords do not match' do
        @user.password_confirmation = '321'
        @user.save
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'is not valid when password exceeds 72 characters' do
        @user.password = 'uinnmnblyxspzyscebgdtzfjbuptmrraovygjfhdnteqfdfkxefmembygnlcghkwryvfxgfriucebebxhibnhqluilvkufezcmzqjeqwqickiprikxkedr'
        @user.save
        expect(@user.errors.full_messages).to include('Password is too long (maximum is 72 characters)')
      end
      it 'is not valid when password is shorter than 4 characters' do
        @user.password = 'p'
        @user.password_confirmation = 'p'
        @user.save
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 4 characters)')
      end
    end
    context 'Email Address' do
      it 'Email address must be unique' do
        @different_user = User.new({
                                     first_name: 'First Name',
                                     last_name: 'Last Name',
                                     email: 'EMAIL',
                                     password: '1234',
                                     password_confirmation: '1234'
                                   })
        @user.save
        @different_user.save
        expect(@different_user.errors.full_messages).to include('Email has already been taken')
      end
      it 'Email address will be forced to lowercase before save' do
        @user.email = 'EMAIL'
        @user.save
        expect(@user).to have_attributes(email: 'email')
      end
    end
  end

  describe '.authenticate_with_credentials' do
    @different_user = User.new({
                                 first_name: 'Different First Name',
                                 last_name: 'Last Name',
                                 email: 'different-email',
                                 password: '12345',
                                 password_confirmation: '12345'
                               })
    context 'Email address is entered correctly' do
      it 'should return user if authenticated' do
        @user.save
        returned_user = User.authenticate_with_credentials('email', '1234')
        expect(returned_user).to have_attributes(first_name: 'First Name', email: 'email')
      end
      it 'should return nil if not authenticated' do
        @user.save
        returned_user = User.authenticate_with_credentials('email', '12345')
        expect(returned_user).to be_nil
      end
    end
    context 'Email address is not entered correctly' do
      it 'should return user if authenticated even with trailing spaces in the email' do
        @user.save
        returned_user = User.authenticate_with_credentials(' email ', '1234')
        expect(returned_user).to have_attributes(first_name: 'First Name', email: 'email')
      end
      it 'should return user if authenticated even with email in incorrect case' do
        @user.email = 'EMAIL'
        @user.save
        returned_user = User.authenticate_with_credentials(' EmAiL ', '1234')
        expect(returned_user).to have_attributes(first_name: 'First Name', email: 'email')
      end
    end
  end
end
