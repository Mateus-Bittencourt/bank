class User < ApplicationRecord
  has_many :transactions
  validates :email, :full_name, presence: true
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  before_create do
    self.account_number = "0000#{User.last.account_number.to_i + 1}" if User.count.positive?
  end


  validates :cpf, uniqueness: true
  validate :validate_cpf
  validates :validate_cpf, length: { maximum: 14 }

  def validate_cpf
    errors.add(:cpf, "Inválido") unless cpf.valid_cpf?
  end
end
