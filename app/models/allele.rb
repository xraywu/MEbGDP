class Allele < ActiveRecord::Base #Corresponding to the allele table in mysql
  belongs_to :gene, :primary_key => "mgi_id", :foreign_key => "gene_mgi"
  attr_accessible :allele_mgi, :allele_name, :allele_symbol, :allele_type, :gene_mgi
end
