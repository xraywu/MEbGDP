class Prediction
  include ActiveModel::Validations  #Extend the model to allow validation and client side validation
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :omim_id, :top_results, :lambda, :eta, :gamma, :network
  
  #Validation criteria for prediction parameter
  validates :omim_id, :presence => true, :numericality => { :greater_than => 0, :only_integer => true }
  validates :top_results, :presence => true, :numericality => { :greater_than => 0, :less_than => 2000, :only_integer => true }
  validates :lambda, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validates :eta, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validates :gamma, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validate :validate_networks #Custom validator for prediction method
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def validate_networks
    @allowed_network = ["getSemanPrior","getSemanNPrior","getPPIPrior","getPPINPrior"]  #Allowed keywords
    if network.nil? # At least one method should be selected
      errors.add(:network, "Select at least 1 network!")
    else
      network.each do |network_name|  #Check if all submitted method name is valid
        unless @allowed_network.include?(network_name)
          errors.add(:network, "Please use valid method name!")
          break
        end
      end
    end
  end
  
  
end