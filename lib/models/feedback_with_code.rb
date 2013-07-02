require "models/rand_code"

module FeedbackWithCode
  include RandCode
  protected
  def generate_code
    self.code = rand_code(30)
  end
  
end
