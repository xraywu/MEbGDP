class GenesController < ApplicationController
  def search
    @gene = Gene.find_by_symbol(params[:symbol])
    @title = "Gene Information"
    render :layout => "noLayout"
  end
end
