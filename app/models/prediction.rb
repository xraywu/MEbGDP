class Prediction
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :omim_id, :top_results, :lambda, :eta, :gamma, :network
 
  validates :omim_id, :presence => true, :numericality => { :greater_than => 0, :only_integer => true }
  validates :top_results, :presence => true, :numericality => { :greater_than => 0, :less_than => 2000, :only_integer => true }
  validates :lambda, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validates :eta, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validates :gamma, :presence => true, :numericality => { :greater_than => 0, :less_than => 1 }
  validates :network, :presence => { :message => "should be selected!" }
  
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end