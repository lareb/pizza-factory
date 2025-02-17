# frozen_string_literal: true

# spec/validators/order_validator_spec.rb

require 'rails_helper'

RSpec.describe OrderValidator, type: :validator do
  let(:veg_category) { create(:category, name: 'Vegetarian') }
  let(:non_veg_category) { create(:category, name: 'Non-Vegetarian') }
  let(:paneer_category) { create(:category, name: 'Paneer') }
  let(:pizza_vegetarian) { create(:pizza, category: veg_category) }
  let(:pizza_non_vegetarian) { create(:pizza, category: non_veg_category) }
  let(:crust) { create(:crust) }
  let(:topping_veg) { create(:topping, category: veg_category) }
  let(:topping_non_veg) { create(:topping, category: non_veg_category) }
  let(:topping_paneer) { create(:topping, category: paneer_category) }
  let(:order_item) { build(:order_item, pizza: pizza_vegetarian, crust: crust) }

  describe '#valid?' do
    context 'when pizza is vegetarian' do
      it 'validates vegetarian pizza cannot have non-vegetarian toppings' do
        order_item.order_toppings.build(topping: topping_non_veg)

        order = build(:order, order_items: [order_item])
        validator = described_class.new(order)

        expect(validator.valid?).to be false
        expect(validator.errors).to include('Vegetarian pizza cannot have non-vegetarian toppings.')
      end

      it 'validates non-veg toppings cannot include paneer' do
        order_item.pizza = pizza_non_vegetarian
        order_item.order_toppings.build(topping: topping_paneer)

        order = build(:order, order_items: [order_item])
        validator = described_class.new(order)

        expect(validator.valid?).to be false
        expect(validator.errors).to include('Non-vegetarian pizza cannot have paneer topping.')
      end

      it 'validates only one non-veg topping for non-veg pizza' do
        order_item.pizza = pizza_non_vegetarian
        order_item.order_toppings.build(topping: topping_non_veg)
        order_item.order_toppings.build(topping: topping_non_veg)

        order = build(:order, order_items: [order_item])
        validator = described_class.new(order)

        expect(validator.valid?).to be false
        expect(validator.errors).to include('Only one non-veg topping can be added to a non-vegetarian pizza.')
      end
    end

    context 'when pizza has multiple crust types' do
      it 'validates only one type of crust per pizza' do
        order_item_1 = build(:order_item, pizza: pizza_vegetarian, crust: crust)
        order_item_2 = build(:order_item, pizza: pizza_vegetarian, crust: create(:crust))

        order = build(:order, order_items: [order_item_1, order_item_2])
        validator = described_class.new(order)

        expect(validator.valid?).to be false
        expect(validator.errors).to include('Only one type of crust can be selected per pizza.')
      end
    end

    context 'when pizza size is large' do
      it 'validates large pizzas can 2 toppings or more' do
        order_item.size = 'large'
        order_item.order_toppings.build(topping: topping_veg)

        order = build(:order, order_items: [order_item])
        validator = described_class.new(order)

        expect(validator.valid?).to be false
        expect(validator.errors).to include('Large pizzas come with 2 free toppings. Extra toppings will be charged.')
      end
    end

    context 'when no errors are present' do
      it 'returns true if no validation errors' do
        order_item.order_toppings.build(topping: topping_veg)

        order = build(:order, order_items: [order_item])
        validator = described_class.new(order)

        expect(validator.valid?).to be true
        expect(validator.errors).to be_empty
      end
    end
  end
end
