module FeedbacksControllerMethods
  def survey
    @disabled = Turkee::TurkeeFormHelper::disable_form_fields?(params)
    @feedback_survey = FeedbackSurvey.new
    feedback_controller_name = self.class.name.sub(/Controller/, "")
    @feedback_survey.feedback_controller = feedback_controller_name
    feedback_model_name = feedback_controller_name.singularize
    @feedback_survey.feedback_type = feedback_model_name
    @feedback_survey.feedback_type = "ImpressionFeedback" if feedback_model_name == "ImpressionVoteFeedback"
    @feedback_url = send("new_design_#{feedback_model_name.underscore}_url", :params => params)
    respond_to do |format|
      format.html {render "shared/feedback_survey", :layout => "feedback"}
    end
  end

  protected
  def get_element_boxareas
    @boxareas = []
    element_feedbacks = @design.element_feedbacks
    element_feedbacks.each do |feedback|
      feedback.boxareas.each {|boxarea| @boxareas << {name: feedback.name, x1: boxarea.top_left_x, y1: boxarea.top_left_y, x2: boxarea.bottom_right_x, y2:boxarea.bottom_right_y}}
    end
  end

  def check_turker
    if params[:workerId].nil?
      respond_to do |format|
        message = "Please accept the HIT first."
        format.html { render :text => message }
        format.json { render :json => {:error => message }, :status => :unprocessable_entity }
      end
      return false
    end
    @turker = Turker.where(:worker_id => params[:workerId]).first
    if @turker.nil?
      @turker = Turker.new
      @turker.worker_id = params[:workerId]
    end
    return true
  end

  def authorize_design
    feedback_controller_name = self.class.name.sub(/Controller/,"")
    if !@design.is_published || @design.is_feedback_done || @design.send("#{feedback_controller_name.underscore}_access_code") != params[:access_code]
      respond_to do |format|
        message = "No Authorization."
        format.html {render :text => message }
        format.json {render :json => {:error => message }, :status => :unprocessable_entity }
      end
    end

  end
end
