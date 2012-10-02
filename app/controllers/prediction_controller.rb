class PredictionController < ApplicationController
  
  def parameter
    @disease = Disease.find_by_omim_id(params[:omim_id])
  end

  def predict
    
  end

end
