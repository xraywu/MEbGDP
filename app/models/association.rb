class Association < ActiveRecord::Base #Corresponding to the association table in mysql, relationship between disease and gene
  belongs_to :gene
  belongs_to :disease
  
  attr_accessible :disease_id, :gene_id
end
