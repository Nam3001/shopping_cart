class Types::PaginationType < Types::BaseObject
  field :current_page, Int, null: false
  field :total_pages, Int, null: false
  field :total_count, Int, null: false
end