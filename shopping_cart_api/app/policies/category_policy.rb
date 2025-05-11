class CategoryPolicy
  attr_reader :user, :category

  def initialize(user, category)
    @user = user
    @category = category
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def products?
    user.admin?
  end

  def index?
    true
  end

  def show?
    true    
  end
end
