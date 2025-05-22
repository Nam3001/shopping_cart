class ProductAttributeSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  has_many :attribute_values

  def attribute_values
    object.attribute_values.order(updated_at: :desc).map do |attribute_value|
      {
        id: attribute_value.id,
        value: attribute_value.value,
        created_at: attribute_value.created_at,
        updated_at: attribute_value.updated_at
    }
    end
  end
end