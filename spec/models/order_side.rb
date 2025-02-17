# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderSide, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:side) }
  end

  describe '#price' do
    let(:side) { create(:side, price: 5) }
    let(:order_side) { create(:order_side, side: side) }

    it 'returns the price of the associated side' do
      expect(order_side.price).to eq(5)
    end
  end
end
