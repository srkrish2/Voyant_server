class DesignsController < ApplicationController
  #before_filter :find_design, :only => [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def feedbacks
    #@design = Design.find(params[:id])

    @json_data = {}
    @json_data[:nodes] = []
    @json_data[:range] = {}

    @design.element_feedbacks.each do |feedback|
      feedback.boxareas.each do |boxarea|
        node = {}
        node[:id] = boxarea.id
        node[:type] = "eleorg"
        node[:cord] = [boxarea.top_left_x, boxarea.top_left_y, boxarea.bottom_right_x, boxarea.bottom_right_y]
        node[:x] = (boxarea.top_left_x + boxarea.bottom_right_x) * 0.5
        node[:y] = (boxarea.top_left_y + boxarea.bottom_right_y) * 0.5
        node[:size] = (boxarea.bottom_right_x - boxarea.top_left_x) * (boxarea.bottom_right_y - boxarea.top_left_y)
        node[:content] = {}
        node[:content][:subtype] = feedback.configuration.name
        node[:content][:score] = 0
        node[:content][:txt] = feedback.name
        node[:quality] = 0
        @json_data[:nodes] << node
      end
    end
    
    min_vote = -10000000
    max_vote = 10000000

    @design.first_notice_feedbacks.each do |feedback|
      boxarea = feedback.boxarea
      element_feedback = feedback.element_feedback
      node = {}
      node[:id] = boxarea.id
      node[:type] = "ele"
      node[:cord] = [boxarea.top_left_x, boxarea.top_left_y, boxarea.bottom_right_x, boxarea.bottom_right_y]
      node[:x] = (boxarea.top_left_x + boxarea.bottom_right_x) * 0.5
      node[:y] = (boxarea.top_left_y + boxarea.bottom_right_y) * 0.5
      node[:size] = (boxarea.bottom_right_x - boxarea.top_left_x) * (boxarea.bottom_right_y - boxarea.top_left_y)
      node[:content] = {}
      node[:content][:subtype] = element_feedback.configuration.name
      node[:content][:score] = element_feedback.vote
      min_vote = element_feedback.vote if min_vote > element_feedback.vote
      max_vote = element_feedback.vote if max_vote < element_feedback.vote
      node[:content][:txt] = element_feedback.name
      node[:quality] = 0
      @json_data[:nodes] << node
    end

    @json_data[:range][:ele] = [min_vote, max_vote]

    min_vote = -1000000000
    max_vote = 1000000000
    @design.impression_feedbacks.each do |feedback|
      feedback.boxareas.each do |boxarea|
        node = {}
        node[:id] = boxarea.id
        node[:type] = "imp"
        node[:cord] = [boxarea.top_left_x, boxarea.top_left_y, boxarea.bottom_right_x, boxarea.bottom_right_y]
        node[:x] = (boxarea.top_left_x + boxarea.bottom_right_x) * 0.5
        node[:y] = (boxarea.top_left_y + boxarea.bottom_right_y) * 0.5
        node[:size] = (boxarea.bottom_right_x - boxarea.top_left_x) * (boxarea.bottom_right_y - boxarea.top_left_y)
        node[:content] = {}
        node[:content][:subtype] = feedback.name
        node[:content][:score] = feedback.vote
        min_vote = feedback.vote if min_vote > feedback.vote
        max_vote = feedback.vote if max_vote < feedback.vote
        node[:content][:txt] = boxarea.description
        node[:quality] = 0
        @json_data[:nodes] << node
      end
    end
    
    @json_data[:range][:imp] = [min_vote, max_vote]

    goal_configurations = @design.goal_configurations
    @design.goal_feedbacks.each do |feedback|
      boxarea = feedback.boxarea
      configuration = feedback.configuration
      node = {}
      node[:id] = boxarea.id
      node[:type] = "goal"
      node[:cord] = [boxarea.top_left_x, boxarea.top_left_y, boxarea.bottom_right_x, boxarea.bottom_right_y]
      node[:x] = (boxarea.top_left_x + boxarea.bottom_right_x) * 0.5
      node[:y] = (boxarea.top_left_y + boxarea.bottom_right_y) * 0.5
      node[:size] = (boxarea.bottom_right_x - boxarea.top_left_x) * (boxarea.bottom_right_y - boxarea.top_left_y)
      node[:content] = {}
      node[:content][:subtype] = "goal#{goal_configurations.index(configuration)}"
      node[:content][:score] = feedback.rating + 3
      node[:content][:txt] = boxarea.description
      node[:quality] = 0
      @json_data[:nodes] << node

    end

    @json_data[:range][:goal] = [-3,3]

    guideline_configurations = @design.guideline_configurations
    @design.guideline_feedbacks.each do |feedback|
      boxarea = feedback.boxarea
      configuration = feedback.configuration
      node = {}
      node[:id] = boxarea.id
      node[:type] = "guide"
      node[:cord] = [boxarea.top_left_x, boxarea.top_left_y, boxarea.bottom_right_x, boxarea.bottom_right_y]
      node[:x] = (boxarea.top_left_x + boxarea.bottom_right_x) * 0.5
      node[:y] = (boxarea.top_left_y + boxarea.bottom_right_y) * 0.5
      node[:size] = (boxarea.bottom_right_x - boxarea.top_left_x) * (boxarea.bottom_right_y - boxarea.top_left_y)
      node[:content] = {}
      node[:content][:subtype] = "guide#{guideline_configurations.index(configuration)}"
      node[:content][:score] = feedback.rating + 3
      node[:content][:txt] = boxarea.description
      node[:quality] = 0
      @json_data[:nodes] << node
    end

    @json_data[:range][:guide] = [-3,3]

    @json_data[:isshown] = {}
    @json_data[:isshown][:eleorg] = true
    @json_data[:isshown][:notice] = true
    @json_data[:isshown][:imp] = true
    @json_data[:isshown][:goal] = true
    @json_data[:isshown][:criteria] = true

    @json_data[:legend] = {}
    goal_title = []
    goal_content = []
    @design.goal_configurations.each do |configuration|
      goal_title << configuration.title 
      goal_content << configuration.description
    end
    @json_data[:legend][:goal] = {title: goal_title, content: goal_content}

    guide_title = []
    guide_content = []
    @design.guideline_configurations.each do |configuration|
      guide_title << configuration.title
      guide_content << configuration.description
    end
    @json_data[:legend][:guide] = {title: guide_title, content: guide_content}
    gon.json_data = @json_data

    respond_to do |format|
      format.html
    end

  end

  # GET /designs
  # GET /designs.xml
  def index
    #@designs = Design.all
    @design = Design.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @designs }
    end
  end

  # GET /designs/1
  # GET /designs/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @design }
    end
  end

  # GET /designs/new
  # GET /designs/new.xml
  def new
    @design = Design.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /designs/1/edit
  def edit
  end

  # POST /designs
  # POST /designs.xml
  def create
    @design = Design.new(params[:design])
    @design.user_id = current_user.id

    respond_to do |format|
      if @design.save
        flash[:notice] = 'Design was successfully created.'
        format.html { redirect_to(edit_design_url(@design)) }
        format.json  { render :json => @design, :status => :created, :location => @design }
      else
        format.html { render :action => "new" }
        format.json  { render :json => {:model_error => @design.errors}, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /designs/1
  # PUT /designs/1.xml
  def update
    respond_to do |format|
      # Set audience_configuration
      audience_configuration = AudienceConfiguration.new
      genders = []
      params[:audience][:gender].each_with_index {|gender,index| genders << index if gender }
      audience_configuration.gender = genders.join(";")

      ages = []
      params[:audience][:age].each_with_index {|age, index| ages << index if age}
      audience_configuration.age = ages.join(";")

      countries = []
      params[:audience][:country].each_with_index {|country, index| countries << index if country}
      audience_configuration.country = countries.join(";")
      audience_configuration.design_experience = ""

      audience_configuration.design = @design

      # Set element_configuration
      element_configurations = []
      params[:element].each do |index,e|
        element_configuration = ElementConfiguration.new(e)
        element_configuration.design = @design
        element_configurations << element_configuration
      end

      # Set first_notice_configuration
      first_notice_configuration = FirstNoticeConfiguration.new(:is_required => params[:is_required][:first_notice])
      first_notice_configuration.design = @design

      # Set impression_configuration
      impression_configuration = ImpressionConfiguration.new(:is_required => params[:is_required][:impression])
      impression_configuration.design = @design

      # Set goal_configuration
      goal_configurations = []
      params[:goal].each do |key,g|
        goal_configuration = GoalConfiguration.new(g)
        goal_configuration.design = @design
        goal_configurations << goal_configuration
      end

      # Set guideline_configuration
      guideline_configurations = []
      params[:guideline].each do |key,g|
        guideline_configuration = GuidelineConfiguration.new(g)
        guideline_configuration.design = @design
        guideline_configurations << guideline_configuration
      end

      Design.transaction do
        begin
          @design.audience_configuration.delete if @design.audience_configuration
          @design.element_configurations.delete_all
          @design.first_notice_configuration.delete if @design.first_notice_configuration
          @design.impression_configuration.delete if @design.impression_configuration
          @design.goal_configurations.delete_all
          @design.guideline_configurations.delete_all


          audience_configuration.save!
          element_configurations.each {|e| e.save!}
          first_notice_configuration.save!
          impression_configuration.save!
          goal_configurations.each {|g| g.save!}
          guideline_configurations.each {|g| g.save!}

          flash[:notice] = 'Design was successfully updated.'
          format.html { redirect_to(@design) }
          format.json  { render :json => {:status => :ok }}

        rescue
          format.html { render :action => "edit" }
          format.json  { render :json => {:error => "Can not save the those configurations"}, :status => :unprocessable_entity }
          #raise "fkjdlfjsdklfjsdkljffj"

        end
      end
    end
  end

  # DELETE /designs/1
  # DELETE /designs/1.xml
  def destroy
    @design.destroy

    respond_to do |format|
      format.html { redirect_to(designs_url) }
      format.xml  { head :ok }
    end
  end

  def request_feedback_for
    Design.transaction do
      respond_to do |format|
        #begin
          @design.publish!

          flash[:notice] = 'Design was successfully published.'
          format.html { redirect_to(designs_url) }
        #rescue
          #flash[:notice] = 'Design can not be published.'
          #format.html { redirect_to(designs_url) }
        #end
      end

    end


  end

  private
  def find_design
    @design = Design.find(params[:id])
  end

end

