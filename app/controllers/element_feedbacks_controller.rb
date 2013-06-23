class ElementFeedbacksController < ApplicationController
  #before_filter :find_elementFeedback, :only => [:show, :edit, :update, :destroy]
  load_resource :design
  load_resource :element_feedback, :through => :design

  # GET /elementFeedbacks
  # GET /elementFeedbacks.xml
  def index
    #@element_feedbacks = ElementFeedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @element_feedbacks }
    end
  end

  # GET /elementFeedbacks/1
  # GET /elementFeedbacks/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @element_feedback }
    end
  end

  # GET /elementFeedbacks/new
  # GET /elementFeedbacks/new.xml
  def new
    #@element_feedback = ElementFeedback.new
    @configuration = @design.element_configurations.sample

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @element_feedback }
    end
  end

  # GET /elementFeedbacks/1/edit
  def edit
  end

  # POST /elementFeedbacks
  # POST /elementFeedbacks.xml
  def create
    @element_feedback = ElementFeedback.new(params[:elementFeedback])

    respond_to do |format|
      if @element_feedback.save
        flash[:notice] = 'ElementFeedback was successfully created.'
        format.html { redirect_to(@element_feedback) }
        format.xml  { render :xml => @element_feedback, :status => :created, :location => @element_feedback }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @element_feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /elementFeedbacks/1
  # PUT /elementFeedbacks/1.xml
  def update
    respond_to do |format|
      if @element_feedback.update_attributes(params[:elementFeedback])
        flash[:notice] = 'ElementFeedback was successfully updated.'
        format.html { redirect_to(@element_feedback) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @element_feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /elementFeedbacks/1
  # DELETE /elementFeedbacks/1.xml
  def destroy
    @element_feedback.destroy

    respond_to do |format|
      format.html { redirect_to(elementFeedbacks_url) }
      format.xml  { head :ok }
    end
  end

  private
    def find_elementFeedback
      @element_feedback = ElementFeedback.find(params[:id])
    end

end

