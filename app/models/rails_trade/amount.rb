module RailsTrade::Amount
  extend ActiveSupport::Concern
  included do
    attribute :item_amount, :decimal, default: 0
    attribute :overall_additional_amount, :decimal, default: 0
    attribute :overall_reduced_amount, :decimal, default: 0
    attribute :amount, :decimal, default: 0

    has_many :trade_items, as: :trade, inverse_of: :trade, dependent: :destroy
    has_many :trade_promotes, -> { overall }, as: :trade, inverse_of: :trade, dependent: :destroy  # overall can be blank
    
    accepts_nested_attributes_for :trade_items
    accepts_nested_attributes_for :trade_promotes
  end

  def compute_amount
    self.item_amount = trade_items.sum(&:amount)
    self.overall_additional_amount = trade_promotes.select(&->(o){ o.amount >= 0 }).sum(&:amount)
    self.overall_reduced_amount = trade_promotes.select(&->(o){ o.amount < 0 }).sum(&:amount)
    self.amount = item_amount + overall_additional_amount + overall_reduced_amount
    self
  end
  
  def compute_saved_amount
    _item_amount = trade_items.sum(:amount)
    _promote_amount = trade_promotes.sum(:amount)
    _item_amount + _promote_amount
  end

  def reset_amount
    self.item_amount = trade_items.sum(:amount)
    self.overall_additional_amount = trade_promotes.default_where('amount-gte': 0).sum(:amount)
    self.overall_reduced_amount = trade_promotes.default_where('amount-lt': 0).sum(:amount)
    self.amount = item_amount + overall_additional_amount + overall_reduced_amount
    self.valid?
    self.changes
  end

  def reset_amount!(*args)
    self.reset_amount
    self.save(*args)
  end
  
end
