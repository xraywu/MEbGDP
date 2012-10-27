module PredictionHelper
  
  def enableValidator
    return raw "$('#new_prediction').enableClientSideValidations();"
  end

  def resetValidator
    return raw "$('#new_prediction').resetClientSideValidations();"
  end
  
  def checkGeneLocation(symbol, linkage_interval, omim_id)
    gene = Gene.find_by_symbol(symbol)
    unless gene.nil?
      gene.diseases.each do |disease|
        if disease.omim_id.to_s == omim_id
          return "gene-known-to-disease"
        end
      end      
      
      unless linkage_interval.nil?
        linkage_interval.each do |interval|
          return "gene-in-interval" if gene.in_interval?(interval)
        end
      end
    end
    return
  end

end
