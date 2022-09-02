class User < ApplicationRecord
  has_many :transactions
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create do
    self.account_number = User.last.account_number + 1 if User.count.positive?
  end
end
