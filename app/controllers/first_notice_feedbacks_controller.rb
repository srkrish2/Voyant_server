class FirstNoticeFeedbacksController < ApplicationController
  load_resource :design
  load_resource :first_notice_feedback, :through => :design, :expecpt => :batch_create

  def new
    @configuration = @design.element_configurations.sample
    @element_feedbacks = @design.element_feedbacks.where(:configuration_id => @configuration.id)

  end

  def create
    FirstNoticeFeedback.transaction do
      respond_to do |format|
        begin
          element_feedback = @design.element_feedbacks.find(params[:element_feedback_id])
          element_feedback.vote += 1
          element_feedback.save!

          first_notice_feedback = FirstNoticeFeedback.new
          first_notice_feedback.design = @design
          first_notice_feedback.element_feedback = element_feedback
          first_notice_feedback.save!

          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = first_notice_feedback.create_boxarea(:top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
          boxarea = turker
          boxarea.save!
          format.json {render :json => {:message => "Save Successfully"}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end
  end

end
