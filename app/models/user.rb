class User < ActiveRecord::Base
  
has_secure_password
validates_length_of :password, minimum: 4

validates_presence_of :email
validates_presence_of :first_name
validates_presence_of :last_name

validates_uniqueness_of :email, case_sensitive: false

before_save { email.downcase! }

def self.authenticate_with_credentials(email_address, password)
  stripped_email_address =  email_address.strip.downcase
  user = User.find_by_email(stripped_email_address)
  if user && user.authenticate(password)
    return user
  else
    return nil
  end
end

end