module ProductService
  class Destroy < ApplicationService

    def call
      ActiveRecord::Base.transaction do
        begin
          product = Product.find(params[:id])
          product.destroy!

        rescue ActiveRecord::RecordNotFound => e
          raise ActiveRecord::Rollback, e.message
        rescue ActiveRecord::RecordInvalid => e
          raise ActiveRecord::Rollback, e.message
        rescue => e
          raise ActiveRecord::Rollback, e.message
        end
      end
    end
  end
end