class DesignsController < ApplicationController
  #before_filter :find_design, :only => [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /designs
  # GET /designs.xml
  def index
    @designs = Design.all

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
    @design = Design.new
    @design.name = params[:name]
    @design.description = params[:description]
    @design.user_id = current_user.id

    respond_to do |format|
      if @design.save
        flash[:notice] = 'Design was successfully created.'
        format.html { redirect_to(@design) }
        format.json  { render :json => @design, :status => :created, :location => @design }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @design.errors, :status => :unprocessable_entity }
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
          @design.audience_configuration.delete
          @design.element_configurations.delete_all
          @design.first_notice_configuration.delete
          @design.impression_configuration.delete
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
          format.json  { render :json => {:message => "Can not save the those configurations", :status => :unprocessable_entity }}

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

  private
    def find_design
      @design = Design.find(params[:id])
    end

end

