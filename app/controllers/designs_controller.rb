class DesignsController < ApplicationController
  before_filter :find_design, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

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
    render
    return
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
      if @design.update_attributes(params[:design])
        flash[:notice] = 'Design was successfully updated.'
        format.html { redirect_to(@design) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @design.errors, :status => :unprocessable_entity }
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

