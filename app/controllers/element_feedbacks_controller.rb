require 'controllers/feedbacks_controller_methods'
require 'models/rand_code'

class ElementFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  include RandCode
  load_resource :design
  before_filter :authorize_design
  before_filter :check_turker
  load_resource :element_feedback, :through => :design, :new => [:survey]

  def new
    @configuration = @design.element_configurations.where("feedbacks_num > 0").sample

    respond_to do |format|
      format.html {render :layout => "feedback"}# new.html.erb
      format.xml  { render :xml => @element_feedback }
    end
  end


  # POST /elementFeedbacks
  # POST /elementFeedbacks.xml
  def batch_create
    ElementFeedback.transaction do
      respond_to do |format|
        begin
          code = rand_code
          element_feedback = nil
          configuration = @design.element_configurations.find(params[:configuration_id])
          params[:feedbacks].each do |feedback|
            feedback[:name] = feedback[:name].strip.singularize.downcase
            element_feedback = ElementFeedback.where(:design_id => @design.id, :configuration_id => configuration.id, :name => feedback[:name]).first
            if element_feedback.nil?
              element_feedback = ElementFeedback.new(:name => feedback[:name])
              element_feedback.design = @design
              element_feedback.configuration = configuration
              element_feedback.save!
            end
            turker = Turker.where(:worker_id => params[:worker_id]).first || raise
            boxarea = element_feedback.boxareas.create(:top_left_x => feedback[:x1], :top_left_y => feedback[:y1], :bottom_right_x => feedback[:x2], :bottom_right_y => feedback[:y2])
            boxarea.turker = turker
            boxarea.code = code
            boxarea.save!
          end

          configuration.feedbacks_num -= 1
          configuration.save!

          format.json  { render :json => {:message => "Save Successfully", :code => code}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end

  end

end

