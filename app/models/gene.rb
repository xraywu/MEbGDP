class Gene < ActiveRecord::Base
  has_many :allele, :primary_key => "mgi_id", :foreign_key => "gene_mgi"
  has_many :associations
  has_many :diseases, :through => :associations
  
  attr_accessible :accession_numbers, :chromosome_location, :ensembl_gene_id, :hgnc_id, :mgi_id, :name, :name_synonym, :refseq_id, :symbol, :synonym, :uniprot_id
  
  def in_interval?(interval)
    #TODO REAL COMPARISON
    return true if self.chromosome_location =~ /#{interval}/
  end

end
