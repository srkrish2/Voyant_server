require 'controllers/feedbacks_controller_methods'
require 'models/rand_code'

class GuidelineFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  include RandCode
  load_resource :design
  before_filter :authorize_design
  load_resource :guideline_feedback, :through => :design, :expecpt => :batch_create

  def new
    return if !check_turker
    get_element_boxareas
    @configuration = @design.guideline_configurations.where("feedbacks_num > 0").sample
    @configuration_index = @design.guideline_configurations.index(@configuration)
    @configuration_index = nil if @configuration_index > 3

    respond_to do |format|
      format.html {render :layout => "feedback"}
    end

  end

  def create
    GuidelineFeedback.transaction do
      respond_to do |format|
        guideline_feedback = nil
        code = rand_code
        begin
          configuration = @design.guideline_configurations.find(params[:configuration_id])
          guideline_feedback = GuidelineFeedback.new(:rating => params[:rating])
          guideline_feedback.design = @design
          guideline_feedback.configuration = configuration
          guideline_feedback.save!
          
          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = guideline_feedback.build_boxarea(:description => params[:description], :top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
          boxarea.turker = turker
          boxarea.code = code
          boxarea.save!

          configuration.feedbacks_num -= 1
          configuration.save!

          format.json  { render :json => {:message => "Save Successfully", :code => code }, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end

      end
    end

  end

end
