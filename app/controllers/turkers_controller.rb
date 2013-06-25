class TurkersController < ApplicationController
  def find
    params[:worker_id] ||= ""
    respond_to do |format|
      if params[:worker_id].empty?
        format.json {render :json => {:error => "Please fill your Worker ID"},:status => :unprocessable_entity }
      else
        turkers = Turker.where(:worker_id => params[:worker_id].strip)
        format.json {render :json => {:exist => !turkers.empty?, :status => :ok}}
      end
    end

  end


  def create
    @turker = Turker.new(params[:turker])

    respond_to do |format|
      if @turker.save
        format.json { render :json => @turker.to_json, :status => :ok }
      else
        format.json {render :json => {:model_error => @turker.errors}, :status => :unprocessable_entity}
      end
    end
  end

end
