class Gene < ActiveRecord::Base
  has_many :allele, :primary_key => "mgi_id", :foreign_key => "gene_mgi"
  has_many :associations
  has_many :diseases, :through => :associations
  
  attr_accessible :accession_numbers, :chromosome_location, :ensembl_gene_id, :hgnc_id, :mgi_id, :name, :name_synonym, :refseq_id, :symbol, :synonym, :uniprot_id
  
  def in_interval?(interval)
    interval_single_pattern = /^(\d+|X|Y)+((p|q)\d+(\.\d+)*)$/
    interval_range_pattern = /^(\d+|X|Y)(p|q)((\d+)(\.\d)*)-(p|q)((\d+)(\.\d)*)$/
    interval_simple_pattern = /(.+)(p|q)(.+)/
    
    if interval =~ interval_single_pattern
      return true if self.chromosome_location =~ /#{interval}/
    elsif interval =~ interval_range_pattern
      chromosome = $1
      arm = $2
      min_band = $3
      max_band = $7
      min_band,max_band = max_band,min_band if min_band > max_band
      max_band += 0.99 if max_band.to_i == max_band
      self.chromosome_location =~ interval_simple_pattern
      gene_chromosome = $1
      gene_arm = $2
      gene_band = $3
      
      return true if gene_chromosome == chromosome && gene_arm == arm && gene_band >= min_band && gene_band <= max_band
    end
    
  end

end
