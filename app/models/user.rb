# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#  email           :string(255)
#  role_id         :string(255)
#  firstname       :string(255)
#  lastname        :string(255)
#
# rails generate scaffold user name:string firstname:string lastname:string hashed_password:string salt:string email:string role_id:integer

require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessible :name, :firstname, :lastname, :email, :role_id, :password, :password_confirmation, :hashed_password, :salt
  
  validates :name, length: { minimum: 4 }, :presence => true, :uniqueness => true
  validates :firstname, :lastname, :presence => true
  validates :email, :email_format => {:message => I18n.t('activerecord.models.user.errors_email') }
  
  attr_reader :password
  attr_accessor :password_confirmation
  validates :password, length: { minimum: 6 }, :confirmation => true
  validate :password_must_be_present
  
  has_many :credentials
  #belongs_to :role
    
  def User.authenicate(user_id, password)
    #logger.debug "USER_CREDS: #{user_id}/#{password}"
    if user = find_by_name(user_id)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  
  def password=(password)
    @password= password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  
  private
  
  def password_must_be_present
    errors.add(:password, "Missing Password") unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
