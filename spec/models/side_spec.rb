# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Side, type: :model do
  it { should have_many(:order_sides) }

  describe 'callbacks' do
    let(:side) { create(:side) }

    it 'creates inventory after create' do
      expect(Inventory.find_by(item: side)).not_to be_nil
    end
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
