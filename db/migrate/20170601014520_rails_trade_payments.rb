class RailsTradePayments < ActiveRecord::Migration[5.1]
  def change

    create_table :payments do |t|
      t.references :user
      t.references :payment_method
      t.references :creator
      t.references :organ  # for SaaS
      t.string :type
      t.string :payment_uuid
      t.decimal :total_amount, precision: 10, scale: 2
      t.decimal :fee_amount, precision: 10, scale: 2
      t.decimal :income_amount, precision: 10, scale: 2
      t.decimal :checked_amount, precision: 10, scale: 2, default: 0
      t.decimal :adjust_amount, precision: 10, scale: 2, default: 0
      t.string :notify_type
      t.datetime :notified_at
      t.string :pay_status
      t.string :seller_identifier
      t.string :buyer_name
      t.string :buyer_identifier
      t.string :buyer_bank
      t.string :currency
      t.string :state, index: true
      t.string :comment
      t.boolean :verified, default: true
      t.integer :lock_version
      t.timestamps
    end

    create_table :payment_orders do |t|
      t.references :payment
      t.references :order
      t.decimal :check_amount, precision: 10, scale: 2
      t.string :state, index: true
      t.timestamps
    end

    create_table :payment_methods do |t|
      t.string :type
      t.string :account_name
      t.string :account_num
      t.string :bank
      t.text :extra
      t.boolean :verified
      t.boolean :myself
      t.references :creator
      t.timestamps
    end

    create_table :payment_references do |t|
      t.references :payment_method
      t.references :buyer, polymorphic: true
      t.string :state
      t.timestamps
    end

    create_table :refunds do |t|
      t.references :order
      t.references :payment
      t.references :operator
      t.string :type
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :buyer_identifier
      t.string :comment, limit: 512
      t.integer :state, default: 0
      t.datetime :refunded_at
      t.string :reason, limit: 512
      t.string :currency
      t.string :refund_uuid
      t.timestamps
    end

  end
end
