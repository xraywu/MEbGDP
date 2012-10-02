class DiseasesController < ApplicationController
  def search
    @diseases = Disease.where("omim_id = :keyword OR disease_name LIKE :keyword", 
                              { :keyword => "%#{params[:keyword]}%" })
                       .paginate(:page => params[:page], :per_page => 20)
    @keyword = ""
  end
end
