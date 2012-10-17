class Allele < ActiveRecord::Base
  belongs_to :gene, :primary_key => "mgi_id", :foreign_key => "gene_mgi"
  attr_accessible :allele_mgi, :allele_name, :allele_symbol, :allele_type, :gene_mgi
end
