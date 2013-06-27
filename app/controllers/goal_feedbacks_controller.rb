require 'controllers/feedbacks_controller_methods'

class GoalFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  load_resource :design
  load_resource :goal_feedback, :through => :design, :expecpt => :batch_create

  def new
    get_element_boxareas
    @configuration = @design.goal_configurations.sample

    respond_to do |format|
      format.html
    end

  end

  def create
    GoalFeedback.transaction do
      respond_to do |format|

        begin
          configuration = @design.goal_configurations.find(params[:configuration_id])
          goal_feedback = GoalFeedback.new(:rating => params[:rating])
          goal_feedback.design = @design
          goal_feedback.configuration = configuration
          goal_feedback.save!
          
          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = goal_feedback.build_boxarea(:description => params[:description], :top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
          boxarea.turker = turker
          boxarea.save!

          format.json  { render :json => {:message => "Save Successfully"}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end

      end
    end

  end
end
