class Disease < ActiveRecord::Base
  has_many :associations
  has_many :genes, :through => :associations
  
  attr_accessible :disease_name, :omim_id
end
