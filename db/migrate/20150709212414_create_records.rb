class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :name
      t.integer :score
      t.string :identity
      t.integer :hash_value
      t.string :type
      t.timestamps null: false
    end
  end
end
