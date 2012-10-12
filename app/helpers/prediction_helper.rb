module PredictionHelper
  def enableValidator
    return raw "$('#new_prediction').enableClientSideValidations();"
  end

  def resetValidator
    return raw "$('#new_prediction').resetClientSideValidations();"
  end
end
