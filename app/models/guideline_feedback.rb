# == Schema Information
#
# Table name: guideline_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  rating           :integer          default(1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  code             :string(255)
#

require "models/feedback_with_code"

class GuidelineFeedback < ActiveRecord::Base
  include FeedbackWithCode
  # callbacks
  before_create :generate_code
  
  # Constants
  ExampleText = [
    'A design should closely group elements that have relationships. The design should use space to clearly define groups of elements.',
    'Elements of a design should be aligned. You should be able to see an invisible line connects them.',
    'Repeating colors, shapes, textures, fonts, spatial relationships, etc. can often help unify the entire design.',
    'If the elements (color, size, line thickness, shape, space, etc.) are not the same, then make them very different.'
  ]

  ExamplePositiveExplanation = [
    'This design groups related elements together.',
    'You can see a "hard" edge on the right in the design.',
    'Repeating the font style more obvious can increase the visual organization and the consistency of the design.',
    'Some contrast already happening on the above design, but we can push it further by adding contrast to the elements along the top row.'
  ]

  ExampleNegativeExplanation = [
    'None of the elements connect with any other element in the design.',
    'This centered alignment appears a bit weak. You can only see a "soft" edge in the design.',
    '',
    ''
  ]

  ExamplePositiveImage = [
    "proximity_p.png",
    "alignment_p.png",
    "repetition_p.png",
    "constrast_p.png"
  ]

  ExampleNegativeImage = [
    "proximity_n.png",
    "alignment_n.png",
    "repetition_n.png",
    "constrast_n.png"
  ]


  # Accessible
  attr_accessible :rating
  # Associations
  has_one :boxarea, :as => :feedback, :dependent => :destroy
  belongs_to :design
  belongs_to :configuration, :class_name => "GuidelineConfiguration"
  has_one :survey, :class_name => "FeedbackSurvey", :as => :feedback, :dependent => :destroy
  # Validations
  validates :design_id, :presence => {:message => "Design is required"}
  validates :configuration_id, :presence => {:message => "Configuration is required"}
end
