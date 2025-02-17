# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topping, type: :model do
  it { should belong_to(:category) }
  it { should have_many(:order_toppings) }

  describe 'callbacks' do
    let(:topping) { create(:topping) }

    it 'creates inventory after create' do
      expect(Inventory.find_by(item: topping)).not_to be_nil
    end
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
