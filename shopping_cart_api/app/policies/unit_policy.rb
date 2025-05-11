class UnitPolicy
  attr_reader :user, :unit
  def initialize(user, unit)
    @user = user
    @unit = unit
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

  def index?
    true
  end

  def show?
    true
  end
end
