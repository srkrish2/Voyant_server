class TurkersController < ApplicationController
  def find
    turkers = Turker.where(:worker_id => params[:worker_id].strip)
    respond_to do |format|
      format.json {render :json => {:exist => !turkers.empty?, :status => :ok}}
    end

  end
end
