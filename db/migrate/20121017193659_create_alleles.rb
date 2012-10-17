class CreateAlleles < ActiveRecord::Migration
  def change
    create_table :alleles do |t|
      t.string :allele_mgi
      t.string :allele_symbol
      t.string :allele_name, :limit => 1000
      t.string :allele_type
      t.string :gene_mgi

      t.timestamps
    end
  add_index :alleles, :allele_mgi, :unique => true, :null => false
  add_index :alleles, :gene_mgi, :null => false
  end
end
