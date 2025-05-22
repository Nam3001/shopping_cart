class CreateAttributeValues < ActiveRecord::Migration[8.0]
  def change
    create_table :attribute_values do |t|
      t.string :value, null: false
      t.references :attribute, foreign_key: { to_table: :attributes }, null: false
      t.timestamps
    end
  end
end
