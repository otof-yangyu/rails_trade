class OrderItem < ApplicationRecord
  include ServeAndPromote
  belongs_to :order, autosave: true, inverse_of: :order_items
  belongs_to :cart_item, optional: true, autosave: true
  belongs_to :good, polymorphic: true, optional: true
  belongs_to :provider, optional: true
  has_many :order_promotes, autosave: true
  has_many :order_serves, autosave: true
  has_many :serves, through: :order_serves

  after_initialize if: :new_record? do |oi|
    if cart_item
      self.assign_attributes cart_item.attributes.slice(:good_type, :good_id, :number, :pure_price, :extra)
      #self.advance_payment = self.good.advance_payment if self.advance_payment.to_f.zero?

      cart_item.serve_charges.each do |serve_charge|
        op = self.order_serves.build(serve_charge_id: serve_charge.id, serve_id: serve_charge.serve_id, amount: serve_charge.subtotal)
        op.order = self.order
      end

      cart_item.status = 'ordered'
    end
  end
  after_update_commit :sync_amount, if: -> { saved_change_to_amount? }

  def sync_amount
    order.compute_sum
    order.save
  end

  def compute_promote_and_serve
    self.promote.charges.each do |promote_charge|
      op = self.order_promotes.build(promote_charge_id: promote_charge.id, promote_id: promote_charge.promote_id, amount: promote_charge.subtotal)
      op.order = self.order
    end

    if self.cart_item && self.amount != cart_item.final_price
      self.errors.add :base, 'Amount is not equal to cart items'
    end

    compute_sum
  end

  def compute_sum
    self.serve_sum = self.order_serves.sum(&:amount).to_d
    self.promote_sum = self.order_promotes.sum(&:amount).to_d
    self.amount = self.pure_price + self.serve_sum + self.promote_sum
  end

  def confirm_ordered!
    self.good.order_done
  end

  def confirm_paid!

  end

  def confirm_part_paid!

  end

  def confirm_refund!

  end

end unless RailsTrade.config.disabled_models.include?('OrderItem')

# :cart_item_id, :integer
# :good_type, :string
# :good_id, :integer
# :quantity, :float
# :unit, :string
# :number, :integer, limit: 4, default: 1
# :total_price, :decimal, limit: 24
# :order_at :datetime
# :payed_at :datetime
# :comment, :string
# :deliver_on, :date
# #advance_payment, :decimal, precision: 10, scale: 2



