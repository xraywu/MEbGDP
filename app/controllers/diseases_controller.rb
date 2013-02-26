class DiseasesController < ApplicationController
  def search #Search Disease by OMIM_ID or Disease Name
    @diseases = Disease.where("omim_id LIKE :keyword OR disease_name LIKE :keyword", 
                              { :keyword => "%#{params[:keyword]}%" })
                       .paginate(:page => params[:page], :per_page => 20)  #Paginate to 20 results/page
    @keyword = ""  #Reset keyword
    @title = "Search Result"
  end
end
