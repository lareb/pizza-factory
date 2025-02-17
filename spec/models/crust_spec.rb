# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crust, type: :model do
  it { should have_many(:order_items) }

  describe 'callbacks' do
    let(:crust) { create(:crust) }

    it 'creates inventory after create' do
      expect(Inventory.find_by(item: crust)).not_to be_nil
    end
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
