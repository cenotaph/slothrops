class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :super_admin
      can :manage, :all
    elsif user.role? :inventory_admin
      can :manage, [Book, Creator, Category, Edition, Inventory]
    elsif user.role? :content_admin
      can :manage, [Post]
    end
  end
  
end