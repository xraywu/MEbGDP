class Disease < ActiveRecord::Base  #Corresponding to the disease table in mysql
  has_many :associations
  has_many :genes, :through => :associations
  
  attr_accessible :disease_name, :omim_id
end
