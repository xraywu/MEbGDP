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

end
