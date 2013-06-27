require 'controllers/feedbacks_controller_methods'

class ImpressionFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  load_resource :design
  load_resource :impression_feedback, :through => :design, :expecpt => :batch_create

  def new
    get_element_boxareas
    respond_to do |format|
      format.html
    end

  end

  def batch_create
    ImpressionFeedback.transaction do
      respond_to do |format|
        begin
          params[:feedbacks].each do |feedback|
            feedback[:name] = feedback[:name].singularize.downcase
            impression_feedback = @design.impression_feedbacks.where(:name => feedback[:name]).first
            if impression_feedback.nil?
              impression_feedback = ImpressionFeedback.new(:name => feedback[:name])
              impression_feedback.design = @design
              impression_feedback.save!
            end
            impression_feedback.vote += 1
            impression_feedback.save!

            turker = Turker.where(:worker_id => params[:worker_id]).first || raise
            boxarea = impression_feedback.boxareas.create(:description => feedback[:description], :top_left_x => feedback[:x1], :top_left_y => feedback[:y1], :bottom_right_x => feedback[:x2], :bottom_right_y => feedback[:y2])
            boxarea.turker = turker
            boxarea.save!

          end
          format.json  { render :json => {:message => "Save Successfully"}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end
  end

  def vote
    get_element_boxareas
    @impression_feedbacks = @design.impression_feedbacks
  end
end
