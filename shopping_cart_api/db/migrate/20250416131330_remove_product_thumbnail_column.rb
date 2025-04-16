class RemoveProductThumbnailColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :thumbnail, :string
  end
end
