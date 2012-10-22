class Association < ActiveRecord::Base
  belongs_to :gene
  belongs_to :disease
  
  attr_accessible :disease_id, :gene_id
end
