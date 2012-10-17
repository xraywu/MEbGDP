class CreateGenes < ActiveRecord::Migration
  def change
    create_table :genes do |t|
      t.integer :hgnc_id
      t.string :symbol
      t.string :name
      t.string :synonym
      t.string :name_synonym, :limit => 5000
      t.string :chromosome_location
      t.string :accession_numbers
      t.string :ensembl_gene_id
      t.string :mgi_id
      t.string :refseq_id
      t.string :uniprot_id

      t.timestamps
    end
  add_index :genes, :symbol, :unique => true, :null => false
  add_index :genes, :hgnc_id, :unique => true, :null => false
  add_index :genes, :mgi_id
  end
end
