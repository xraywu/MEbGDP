class GenesController < ApplicationController
  def search  #Search gene by gene symbol
    @gene = Gene.find_by_symbol(params[:symbol])
    @title = "Gene Information"
    @omim_id = params[:omim_id]
    render :layout => "noLayout"  # The results page does need page layout
  end
  
  def compare_phenotype #Return disease by omim_id and gene by symbol name for comparison
    @gene = Gene.find_by_symbol(params[:symbol])
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @title = "Phenotype Comparison"
  end
end
