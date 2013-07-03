# == Schema Information
#
# Table name: turkers
#
#  id                :integer          not null, primary key
#  age               :integer          not null
#  gender            :integer          default(0)
#  country           :string(255)      not null
#  design_experience :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  worker_id         :string(255)
#  email             :string(255)
#

require "validators/email_validator"

class Turker < ActiveRecord::Base
  attr_accessible :age, :gender, :country, :design_experience, :worker_id, :email

  # Validations
  validates :age, :presence => {:message => "Age is required"},
                  :numericality => {:only_integer => true, :greater_than => 0, :message => "Age is invalid"}
  validates :gender, :inclusion => {:in => 0..1, :message => "Gender is invalide"},
                      :presence => {:message => "Gender is required"}
  validates :country, :presence => {:message => "Country is required"}
  validates :design_experience, :inclusion => {:in => 0..2, :message => "Design Experience is invalid"},
                                :presence => {:message => "Design experience is required"}
  validates :worker_id, :presence => {:message => "Worker ID is required"},
                        :uniqueness => {:message => "The Turker has already exist"}
  validates :email, :email => true,
                    :uniqueness => {:case_sensitive => false, :message => "This email has been used"},
                    :allow_blank => true
  # Associations
  has_many :boxareas
end
