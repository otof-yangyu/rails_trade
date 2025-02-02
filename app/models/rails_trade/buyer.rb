module RailsTrade::Buyer
  extend ActiveSupport::Concern

  included do
    attribute :name, :string

    has_many :carts, as: :buyer, dependent: :destroy
    has_many :orders, as: :buyer, inverse_of: :buyer, dependent: :nullify

    has_many :promote_buyers, -> { valid }, as: :buyer, dependent: :destroy
    has_many :promotes, through: :promote_buyers

    has_many :payment_references, as: :buyer, dependent: :destroy, autosave: true
    has_many :payment_methods, through: :payment_references, autosave: true

    scope :credited, -> { where(payment_strategy_id: self.credit_ids) }
  end

  def name_detail
    "#{name} (#{id})"
  end

  def last_overdue_date
    orders.order(overdue_date: :asc).first&.overdue_date
  end

  class_methods do
  
    def credit_ids
      PaymentStrategy.where.not(period: 0).pluck(:id)
    end
    
  end

end
