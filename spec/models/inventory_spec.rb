# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  it { should belong_to(:item) }
  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  describe '.available?' do
    let(:pizza) { create(:pizza) }
    let(:inventory) { Inventory.find_by(item_id: pizza.id) }

    it 'returns true if sufficient inventory exists' do
      expect(Inventory.available?(pizza, 9)).to be true
    end

    it 'returns false if not enough inventory exists' do
      expect(Inventory.available?(pizza, 11)).to be false
    end
  end
end
