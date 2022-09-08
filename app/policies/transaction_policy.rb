class TransactionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.where(user:)
    # end
  end

  def deposit?
    true
  end

  def save_deposit?
    record.user == user
  end

  def withdraw?
    true
  end

  def save_withdraw?
    record.user == user
  end

  def transfer_between_accounts?
    true
  end

  def save_transfer_between_accounts?
    record.user == user
  end

  def index?
    record.user == user
  end
end
