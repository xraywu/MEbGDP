module GenesHelper
  
  def hgnc_link(hgnc_id)
    "http://www.genenames.org/data/hgnc_data.php?hgnc_id=" + hgnc_id.to_s
  end
  
  def ensembl_link(ensemble_id)
    "http://useast.ensembl.org/Multi/Search/Results?species=all;idx=;q=" + ensemble_id.to_s
  end

  def mgi_link(mgi_id)
    "http://www.informatics.jax.org/marker/" + mgi_id.to_s
  end
  
  def refseq_link(refseq_id)
    "http://www.ncbi.nlm.nih.gov/gene/?term=" + refseq_id.to_s
  end
  
  def uniprot_link(uniprot_id)
    "http://www.uniprot.org/uniprot/" + uniprot_id.to_s
  end
  
  def accession_link(accession_number)
    "http://www.ncbi.nlm.nih.gov/gquery?term=" + accession_number.to_s
  end
  
  def comma2linebreaker(string) #Translate commas into html line breaker
    string.gsub(/, /) {|s| "<br />" }
  end
  
  def formatAlleleName(allele)  #Translate allele name into html format
    allele.sub!(/>/) {|s| "</sup>" }
    allele.sub!(/</) {|s| "<sup>" }
    
  end
  
  def mgi_allele_link(mgi_id)
    "http://www.informatics.jax.org/searchtool/Search.do?query=" + mgi_id
  end
  
  def phenomeBrowser_link(mgi_id)
    "http://phenomebrowser.net/explore.php?val=" + mgi_id + "#omim"
  end

end
