module FeedbacksControllerMethods
  protected
  def get_element_boxareas
    @boxareas = []
    element_feedbacks = @design.element_feedbacks
    element_feedbacks.each do |feedback|
      feedback.boxareas.each {|boxarea| @boxareas << {name: feedback.name, x1: boxarea.top_left_x, y1: boxarea.top_left_y, x2: boxarea.bottom_right_x, y2:boxarea.bottom_right_y}}
    end
  end
  
end
