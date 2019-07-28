module RailsTrade::TradePromote
  extend ActiveSupport::Concern
  included do
    attribute :sequence, :integer
    attribute :scope, :string
    attribute :based_amount, :decimal, default: 0  # 基于此价格计算，默认为 trade_item 的 amount，与sequence有关
    attribute :computed_amount, :decimal, default: 0  # 计算出的价格
    attribute :amount, :decimal, default: 0  # 默认等于 computed_amount，如果客服人员修改过价格后，则 amount 会发生变化
    attribute :note, :string  # 备注
    
    belongs_to :trade, polymorphic: true, inverse_of: :trade_promotes
    belongs_to :trade_item, optional: true
    belongs_to :promote
    belongs_to :promote_charge
    belongs_to :promote_good
    belongs_to :promote_buyer, counter_cache: true, optional: true
    
    validates :promote_id, uniqueness: { scope: [:trade_item_id] }
    validates :amount, presence: true
    
    enum scope: {
      single: 'single',
      overall: 'overall'
    }

    after_initialize if: :new_record? do
      if trade_item
        self.trade = trade_item.trade
      end
      if self.promote_good
        self.promote_id = self.promote_good.promote_id
        self.sequence = self.promote.sequence
        self.scope = self.promote.scope
      end
    end
    before_validation :compute_amount
    before_validation :sync_changed_amount, if: -> { amount_changed? }
    after_create_commit :check_promote_buyer
  end

  def compute_amount
    if single?
      value = trade_item.metering_attributes.fetch(promote.metering, 0)
      added_amount = trade_item.trade_promotes.select { |cp| cp.promote.sequence < self.promote.sequence }.sum(&->(o){ o.send(promote.metering) })
      
      self.based_amount = value + added_amount
    else
      value = trade.metering_attributes.fetch(promote.metering, 0)
      added_amount = trade.trade_promotes.select { |cp| cp.promote.sequence < self.promote.sequence }.sum(&->(o){ o.send(promote.metering) })
      
      self.based_amount = value + added_amount
    end

    self.computed_amount = self.promote_charge.final_price(based_amount)
    self.amount = computed_amount if amount.zero?
    self
  end
  
  def sync_changed_amount
    changed_amount = amount - amount_was.to_i
    if amount >= 0
      trade_item.additional_amount += changed_amount if single?
      trade.overall_additional_amount += changed_amount if overall?
    else
      trade_item.reduced_amount += changed_amount if single?
      trade.overall_reduced_amount += changed_amount if overall?
    end
  end

  def check_promote_buyer
    return unless promote_buyer
    self.promote_buyer.update state: 'used'
  end
  
end
