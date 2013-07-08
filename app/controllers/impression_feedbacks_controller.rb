require 'controllers/feedbacks_controller_methods'
require 'models/rand_code'

class ImpressionFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  include RandCode
  load_resource :design
  before_filter :authorize_design
  load_resource :impression_feedback, :through => :design, :expecpt => :batch_create

  def new
    return if !check_turker
    get_element_boxareas

    respond_to do |format|
      format.html do
        render :layout => "feedback"
      end
    end

  end

  def batch_create
    ImpressionFeedback.transaction do
      respond_to do |format|
        impression_feedback = nil
        code = rand_code
        begin
          params[:feedbacks].each do |feedback|
            feedback[:name] = feedback[:name].strip.singularize.downcase
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
            boxarea.code = code
            boxarea.save!

          end

          configuration = @design.impression_configuration
          configuration.feedbacks_num -= 1
          configuration.save!

          format.json  { render :json => {:message => "Save Successfully", :code => code}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end
  end

  protected
  def vote?
    return params[:feedback_action] && params[:feedback_action] == "vote"
  end

end
