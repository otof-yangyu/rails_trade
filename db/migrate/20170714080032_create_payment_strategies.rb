class CreatePaymentStrategies < ActiveRecord::Migration[5.1]
  def change

    create_table :payment_strategies do |t|
      t.string :name
      t.string :strategy
      t.integer :period, default: 0
      t.timestamps
    end

    create_table :promotes do |t|
      t.string :type
      t.string :unit
      t.string :name
      t.datetime :start_at
      t.datetime :finish_at
      t.string :scope
      t.boolean :verified, default: false
      t.boolean :overall, default: false
      t.boolean :discount, default: true
      t.integer :sequence, default: 1
      t.timestamps
    end

    create_table :charges do |t|
      t.references :promote
      t.decimal :min, precision: 10, scale: 2, default: 0
      t.decimal :max, precision: 10, scale: 2, default: 99999999.99
      t.decimal :price, precision: 10, scale: 2
      t.string :type
      t.timestamps
    end

    create_table :order_promotes do |t|
      t.references :order, null: false
      t.references :order_item
      t.references :promote
      t.references :charge
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end

  end
end
