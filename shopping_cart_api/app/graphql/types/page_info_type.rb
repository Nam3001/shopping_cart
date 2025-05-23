module Types
  class PageInfoType < Types::BaseObject
    field :has_next_page, Boolean, null: false
    field :has_previous_page, Boolean, null: false
    field :start_cursor, String, null: false
    field :end_cursor, String, null: false
  end
end
