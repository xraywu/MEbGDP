class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :disease_id
      t.integer :gene_id

      t.timestamps
    end
    add_index :associations, :gene_id, :null => false
    add_index :associations, :disease_id, :null => false
  end
end
