class CreateAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :attributes do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
