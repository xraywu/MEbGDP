class PredictionsController < ApplicationController
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @prediction = Prediction.new
  end

  def predict
    @prediction = Prediction.new(params[:prediction])
    if @prediction.valid?
      # TODO send message here
    else
      @disease = Disease.find_by_omim_id(params[:prediction][:omim_id])
      render :action => 'parameter'
    end
  end

end
