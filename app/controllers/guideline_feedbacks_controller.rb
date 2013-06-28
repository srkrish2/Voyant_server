require 'controllers/feedbacks_controller_methods'

class GuidelineFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  load_resource :design
  load_resource :guideline_feedback, :through => :design, :expecpt => :batch_create

  def new
    get_element_boxareas
    @configuration = @design.guideline_configurations.sample
    @configuration_index = @design.guideline_configurations.index(@configuration)
    @configuration_index = nil if @configuration_index > 3

    respond_to do |format|
      format.html
    end

  end

  def create
    GuidelineFeedback.transaction do
      respond_to do |format|

        begin
          configuration = @design.guideline_configurations.find(params[:configuration_id])
          guideline_feedback = GuidelineFeedback.new(:rating => params[:rating])
          guideline_feedback.design = @design
          guideline_feedback.configuration = configuration
          guideline_feedback.save!
          
          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = guideline_feedback.build_boxarea(:description => params[:description], :top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
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
