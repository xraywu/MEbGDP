class PredictionsController < ApplicationController
  require Rails.root.join('app', 'tasks', 'RwrhJob.rb')
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @prediction = Prediction.new
  end

  def predict
    @parameter = Prediction.new(params[:prediction])
    if @parameter.valid?
       timestamp = Time.new.to_time.to_i
       job = RwrhJob.new(params[:prediction][:omim_id],params[:prediction][:top_results],params[:prediction][:lambda],params[:prediction][:gamma],params[:prediction][:eta],params[:prediction][:network],timestamp)
       job.perform
    else
      @disease = Disease.find_by_omim_id(params[:prediction][:omim_id])
      render :action => 'parameter'
    end
  end

end
