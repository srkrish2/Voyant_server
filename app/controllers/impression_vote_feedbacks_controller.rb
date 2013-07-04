require 'controllers/feedbacks_controller_methods'
require 'models/rand_code'

class ImpressionVoteFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  include RandCode
  load_resource :design
  before_filter :authorize_design
  before_filter :check_turker
  load_resource :impression_feedback, :through => :design, :parent => false

  def new
    qulify = true
    catch :break do
      @design.impression_feedbacks.each do |impression_feedback|
        impression_feedback.boxareas.each do |boxarea|
          if boxarea.turker == @turker
            qulify = false
            throw :break
          end
        end
      end
    end

    if !qulify
      respond_to do |format|
        format.html { render :text => "You are not qulified to perform this task, sorry." }
      end
      return
    end

    get_element_boxareas
    @design.reload
    @impression_feedbacks = @design.impression_feedbacks

    respond_to do |format|
      format.html {render :layout => "feedback"}
    end
  end

  def create
    ImpressionFeedback.transaction do
      respond_to do |format|
        begin
          code = rand_code
          params[:name] = params[:name].singularize.downcase
          impression_feedback = @design.impression_feedbacks.where(:name => params[:name]).first
          impression_feedback.vote += 1
          impression_feedback.save!

          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = impression_feedback.boxareas.create(:description => params[:description], :top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
          boxarea.turker = turker
          boxarea.code = code
          boxarea.save!

          format.json  { render :json => {:message => "Save Successfully", :code => code}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end
  end

end
