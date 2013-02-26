class Gene < ActiveRecord::Base #Corresponding to the gene table in mysql, foreign key to mgi table
  has_many :allele, :primary_key => "mgi_id", :foreign_key => "gene_mgi"
  has_many :associations
  has_many :diseases, :through => :associations
  
  attr_accessible :accession_numbers, :chromosome_location, :ensembl_gene_id, :hgnc_id, :mgi_id, :name, :name_synonym, :refseq_id, :symbol, :synonym, :uniprot_id
  
  def in_interval?(interval)  #Private method to compare gene's location to a linkage interval
    interval_single_pattern = /^(\d+|X|Y)+((p|q)\d+(\.\d+)*)$/  #e.g.12q3.1
    interval_range_pattern = /^(\d+|X|Y)(p|q)((\d+)(\.\d)*)-(p|q)((\d+)(\.\d)*)$/ #e.g.12q3.1-4.5
    interval_simple_pattern = /(.+)(p|q)(.+)/ #e.g.  5q5
    
    if interval =~ interval_single_pattern  #Check the interval's presentation format
      return true if self.chromosome_location =~ /#{interval}/
    elsif interval =~ interval_range_pattern  #For a range, the location should be in between the upper and lower bound
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
