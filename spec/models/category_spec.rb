# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:pizzas).dependent(:destroy) }
  it { should have_many(:toppings).dependent(:destroy) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
