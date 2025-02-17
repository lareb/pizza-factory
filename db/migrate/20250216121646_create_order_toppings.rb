class CreateOrderToppings < ActiveRecord::Migration[8.0]
  def change
    create_table :order_toppings do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :topping, null: false, foreign_key: true

      t.timestamps
    end
  end
end
