class ElementFeedbacksController < ApplicationController
  #before_filter :find_elementFeedback, :only => [:show, :edit, :update, :destroy]
  load_resource :design
  load_resource :element_feedback, :through => :design, :expecpt => :batch_create

  def new
    #@element_feedback = ElementFeedback.new
    @configuration = @design.element_configurations.sample

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @element_feedback }
    end
  end


  # POST /elementFeedbacks
  # POST /elementFeedbacks.xml
  def batch_create
    ElementFeedback.transaction do
      respond_to do |format|
        begin
          params[:feedbacks].each do |feedback|
            configuration = @design.element_configurations.find(params[:configuration_id])
            element_feedback = ElementFeedback.where(:design_id => @design.id, :configuration_id => configuration.id, :name => feedback[:name].singularize).first
            if element_feedback.nil?
              element_feedback = ElementFeedback.new(:name => feedback[:name].singularize)
              element_feedback.design = @design
              element_feedback.configuration = configuration
              element_feedback.save!
            end
            turker = Turker.where(:worker_id => params[:worker_id]).first || raise
            boxarea = element_feedback.boxareas.create(:top_left_x => feedback[:x1], :top_left_y => feedback[:y1], :bottom_right_x => feedback[:x2], :bottom_right_y => feedback[:y2])
            boxarea.turker = turker
            boxarea.save!

          end
          format.json  { render :json => @element_feedback, :status => :created, :location => @element_feedback }
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end

  end

end

