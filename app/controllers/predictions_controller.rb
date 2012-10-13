class PredictionsController < ApplicationController
  require Rails.root.join('app', 'tasks', 'RwrhJob.rb')
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @prediction = Prediction.new
    @title = "Prediction Panel"
    render :layout => "noLayout"
  end

  def predict
    @parameter = Prediction.new(params[:prediction])
    if @parameter.valid?
       @task_id = Time.new.to_time.to_i
       Delayed::Job.enqueue RwrhJob.new(params[:prediction][:omim_id],
                                        params[:prediction][:top_results],params[:prediction][:lambda],
                                        params[:prediction][:gamma],params[:prediction][:eta],
                                        params[:prediction][:network], @task_id)
    else
      @disease = Disease.find_by_omim_id(params[:prediction][:omim_id])
      render :action => 'parameter'
    end
  end
  
  def pollResult
    task_id = params[:task_id]
    task_folder = Rails.root.join('task_temp',task_id)
    if File.exists?("#{task_folder}\\finish")
      #To make real results!
      @results = Dir.entries(task_folder)
    else
      @reulsts = []
    end
  end

end
