class CreateDiseases < ActiveRecord::Migration
  def change
    create_table :diseases do |t|
      t.integer :omim_id
      t.string :disease_name
      t.timestamps
    end
    add_index :diseases, :omim_id, :unique => true
    add_index :diseases, :disease_name
  end
end
