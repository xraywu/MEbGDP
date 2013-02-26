module PredictionHelper
  
  def enableValidator #Initial clientSideValidation gem to validate the prediction parameter
    return raw "$('#new_prediction').enableClientSideValidations();"
  end

  def resetValidator  #Reset clientSideValidation to original format - needed after each validation process
    return raw "$('#new_prediction').resetClientSideValidations();"
  end
  
  def checkGeneLocation(symbol, linkage_interval, omim_id)
    gene = Gene.find_by_symbol(symbol)
    unless gene.nil?
      gene.diseases.each do |disease| #Check if a gene is already linked to a disease in the database
        if disease.omim_id.to_s == omim_id
          return "gene-known-to-disease"  #Tag for DOM selector, used for jQuery selection
        end
      end      
      
      unless linkage_interval.nil?
        linkage_interval.each do |interval| #Check if the gene is in a linkage interval linked to the disease
          return "gene-in-interval" if gene.in_interval?(interval)  #Tag for DOM selector, used for jQuery selection
        end
      end
    end
    return
  end

end
