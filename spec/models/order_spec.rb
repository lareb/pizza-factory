# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:order_sides).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w[Pending Confirmed Cancelled]) }
  end

  describe 'callbacks' do
    it 'calculates total price before save' do
      order = create(:order)
      create(:order_item, order_id: order.id, pizza_id: create(:pizza, price_regular: 10).id, size: 'regular')
      order.reload
      order.save!
      expect(order.total_price).to be > 0
    end
  end

  describe '#calculate_total_price' do
    it 'sums order_items and order_sides prices correctly' do
      order = create(:order)
      expected_price = order.order_items.sum(&:price) + order.order_sides.sum(&:price)
      expect(order.total_price).to eq(expected_price)
    end
  end

  describe '#can_be_fulfilled?' do
    let(:order) { create(:order) }
    let(:pizza) { create(:pizza) }
    let(:crust) { create(:crust) }
    let(:side) { create(:side) }

    before do
      create(:order_item, order: order, pizza: pizza, crust: crust, size: 'regular')
      create(:order_side, order: order, side: side)
      order.reload
    end

    context 'when all items have sufficient inventory' do
      before do
        # Mock for sufficient inventory for pizza, crust, and side
        allow(Inventory).to receive(:available?).with(pizza, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(crust, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(side, 1).and_return(true)
      end

      it 'returns true' do
        expect(order.can_be_fulfilled?).to be true
      end
    end

    context 'when any item has insufficient inventory' do
      before do
        # Mock for insufficient inventory for one item
        allow(Inventory).to receive(:available?).with(pizza, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(crust, 1).and_return(false) # Simulate failure for crust
        allow(Inventory).to receive(:available?).with(side, 1).and_return(true)
      end

      it 'returns false' do
        expect(order.can_be_fulfilled?).to be false
      end
    end
  end

  describe '#confirm!' do
    let(:order) { create(:order) }
    let(:pizza) { create(:pizza) }
    let(:crust) { create(:crust) }
    let(:side) { create(:side) }

    before do
      create(:order_item, order: order, pizza: pizza, crust: crust, size: 'regular')
      create(:order_side, order: order, side: side)
      order.reload
    end

    context 'when inventory is sufficient' do
      before do
        # Mock for sufficient inventory for pizza, crust, and side
        allow(Inventory).to receive(:available?).with(pizza, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(crust, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(side, 1).and_return(true)
        allow(Inventory).to receive(:use_inventory).and_return(true)
      end

      it 'confirms the order' do
        expect(order.confirm!).to be true
        expect(order.reload.status).to eq('Confirmed')
      end
    end

    context 'when inventory is insufficient' do
      before do
        # Mock for insufficient inventory for pizza, crust, and side
        allow(Inventory).to receive(:available?).with(pizza, 1).and_return(true)
        allow(Inventory).to receive(:available?).with(crust, 1).and_return(false) # Simulate failure for crust
        allow(Inventory).to receive(:available?).with(side, 1).and_return(true)
      end

      it 'does not confirm the order' do
        expect(order.confirm!).to be false
        expect(order.errors[:base]).to include('Insufficient inventory')
      end
    end
  end
end
