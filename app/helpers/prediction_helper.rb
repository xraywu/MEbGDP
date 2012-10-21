module PredictionHelper
  
  def enableValidator
    return raw "$('#new_prediction').enableClientSideValidations();"
  end

  def resetValidator
    return raw "$('#new_prediction').resetClientSideValidations();"
  end
  
  def checkGeneLocation(symbol, linkage_interval)
    gene = Gene.find_by_symbol(symbol)
    unless gene.nil?
      linkage_interval.each do |interval|
        if(gene.chromosome_location == interval)
          return "gene-in-interval"
        end
      end
    end
  end

end
