# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pizza, type: :model do
  it { should belong_to(:category) }
  it { should validate_presence_of(:name) }

  describe 'callbacks' do
    let(:pizza) { create(:pizza) }

    it 'creates inventory after create' do
      expect(Inventory.find_by(item: pizza)).not_to be_nil
    end
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
