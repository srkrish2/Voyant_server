require 'controllers/feedbacks_controller_methods'
require 'models/rand_code'

class FirstNoticeFeedbacksController < ApplicationController
  include FeedbacksControllerMethods
  include RandCode
  load_resource :design
  before_filter :authorize_design
  load_resource :first_notice_feedback, :through => :design, :expecpt => :batch_create

  def new
    return if !check_turker
    qulify = true
    catch :break do
      @design.element_feedbacks.each do |element_feedback|
        element_feedback.boxareas.each do |boxarea|
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

    @element_feedbacks = @design.element_feedbacks.shuffle

    respond_to do |format|
      format.html {render :layout => "feedback"}
    end

  end

  def create
    FirstNoticeFeedback.transaction do
      respond_to do |format|
        first_notice_feedback = nil
        code = rand_code
        begin
          element_feedback = @design.element_feedbacks.find(params[:element_feedback_id])
          element_feedback.vote += 1
          element_feedback.save!

          first_notice_feedback = FirstNoticeFeedback.new
          first_notice_feedback.design = @design
          first_notice_feedback.element_feedback = element_feedback
          first_notice_feedback.save!

          turker = Turker.where(:worker_id => params[:worker_id]).first || raise
          boxarea = first_notice_feedback.create_boxarea(:top_left_x => params[:x1], :top_left_y => params[:y1], :bottom_right_x => params[:x2], :bottom_right_y => params[:y2])
          boxarea.turker = turker
          boxarea.code = code
          boxarea.save!

          configuration = @design.first_notice_configuration
          configuration.feedbacks_num -= 1
          configuration.save!

          format.json {render :json => {:message => "Save Successfully", :code => code}, :status => :ok}
        rescue
          format.json  { render :json => {:error => "Can not save the data"}, :status => :unprocessable_entity }
        end
      end
    end
  end

end
