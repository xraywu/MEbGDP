class GenesController < ApplicationController
  def search
    @gene = Gene.find_by_symbol(params[:symbol])
    @title = "Gene Information"
    @omim_id = params[:omim_id]
    render :layout => "noLayout"
  end
  
  def compare_phenotype
    @gene = Gene.find_by_symbol(params[:symbol])
    @disease = Disease.find_by_omim_id(params[:omim_id])
    @title = "Phenotype Comparison"
  end
end
