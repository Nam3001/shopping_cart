class UpdateUnits < ActiveRecord::Migration[8.0]
  def change
    change_table :units do |t|
      t.change :unit_description, :string, null: true
    end
  end
end
