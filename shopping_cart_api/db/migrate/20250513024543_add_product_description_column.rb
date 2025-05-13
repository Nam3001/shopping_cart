class AddProductDescriptionColumn < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.text :description, null: false
    end

    Product.where(description: [nil, '']).update_all(description: 'empty description')
  end
end
