class AddCreatedDateToRecord < ActiveRecord::Migration
  def change
    add_column :records, :created_date, :string
  end
end
