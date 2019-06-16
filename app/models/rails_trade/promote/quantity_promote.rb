module RailsTrade::Promote::QuantityPromote

  def compute_amount(good, number, extra)
    amount = good.unified_quantity * number
    compute_price(amount, extra)
  end

end
