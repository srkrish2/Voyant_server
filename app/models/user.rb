# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  design_experience      :integer          default(0)
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_default_role

  GenderNames = ["Female", "Male"]
  DesignExperienceNames = ["Nothing","Novice","Expert"]
  AgeRanges = {"<=20" => 1..20, "21-30" => 21..30, "31-40" => 31..40, "41-50" => 41..50, "51-60" => 51..60, ">60" => 61..1000}
  CountryNames = ["USA", "India", "UK", "Canada", "others"]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :design_experience
  # Validations

  # Associations
  has_many :projects, :dependent => :destroy
  has_many :designs, :dependent => :destroy
  has_many :guide_templates, :dependent => :destroy
  has_many :system_feedbacks, :as => :user, :dependent => :destroy
  

  protected
  def assign_default_role
    self.add_role :user
  end


end
