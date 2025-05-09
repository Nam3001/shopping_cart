class ProductPolicy
  attr_reader :user, :product
  def initialize(user, product)
    @user = user
    @product = product
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end


  def destroy?
    user&.admin?
  end

  def new?
    user&.admin?
  end

  def edit?
    user&.admin?
  end


  def index?
    true
  end

  def show?
    true
  end
end
