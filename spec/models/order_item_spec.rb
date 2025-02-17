# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:pizza) }
    it { should belong_to(:crust) }
    it { should have_many(:order_toppings).dependent(:destroy) }
  end

  describe 'enums' do
    it { should define_enum_for(:size).with_values(%i[regular medium large]) }
  end

  describe '#price' do
    let(:pizza) { create(:pizza, price_regular: 10, price_medium: 15, price_large: 20) }
    let(:order_item) { create(:order_item, pizza: pizza, size: size) }
    let(:order_topping1) { create(:order_topping, order_item: order_item) }
    let(:order_topping2) { create(:order_topping, order_item: order_item) }

    before do
      order_item.order_toppings << [order_topping1, order_topping2]
    end

    context 'when size is regular' do
      let(:size) { 'regular' }

      it 'returns correct price' do
        expect(order_item.price).to eq(10 + 2 + 2) # Pizza price + toppings
      end
    end

    context 'when size is medium' do
      let(:size) { 'medium' }

      it 'returns correct price' do
        expect(order_item.price).to eq(15 + 2 + 2)
      end
    end

    context 'when size is large' do
      let(:size) { 'large' }

      it 'returns correct price' do
        expect(order_item.price).to eq(20)
      end
    end
  end
end
