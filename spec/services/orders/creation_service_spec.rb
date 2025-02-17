# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Orders::CreationService, type: :service do
  let(:valid_params) do
    {
      order: {
        order_items: [
          { pizza_id: pizza.id, crust_id: crust.id, size: 'medium', topping_ids: [topping.id] }
        ],
        side_ids: [side.id]
      }
    }
  end

  let(:pizza) { create(:pizza) }
  let(:crust) { create(:crust) }
  let(:topping) { create(:topping) }
  let(:side) { create(:side) }

  describe '#call' do
    context 'when order creation is successful' do
      it 'creates an order and returns success' do
        service = described_class.new(valid_params)

        result = service.call

        expect(result.success?).to be(true)
        expect(result.order).to be_persisted
        expect(result.errors).to be_empty
      end
    end

    context 'when pizza or crust selection is invalid' do
      let(:invalid_params) do
        {
          order: {
            order_items: [
              { pizza_id: nil, crust_id: crust.id, size: 'medium', topping_ids: [topping.id] }
            ]
          }
        }
      end

      it 'returns failure with an error message' do
        service = described_class.new(invalid_params)

        result = service.call

        expect(result).not_to be_nil
        expect(result.success?).to be(false)
        expect(result.errors).to include('Invalid pizza or crust selection.')
      end
    end

    context 'when validation fails' do
      let(:invalid_params) do
        {
          order: {
            order_items: [
              { pizza_id: pizza.id, crust_id: crust.id, size: nil, topping_ids: [topping.id] }
            ]
          }
        }
      end

      it 'returns failure with validation errors' do
        service = described_class.new(invalid_params)

        result = service.call

        expect(result.success?).to be(false)
        expect(result.errors).to include("Size can't be blank")
      end
    end

    context 'when an exception is raised' do
      let(:invalid_params) do
        {
          order: {
            order_items: [
              { pizza_id: pizza.id, crust_id: crust.id, size: 'medium' }
            ]
          }
        }
      end

      it 'returns failure with an exception message' do
        allow(Order).to receive(:new).and_raise(ActiveRecord::RecordInvalid.new(Order.new))

        service = described_class.new(invalid_params)

        result = service.call

        expect(result.success?).to be(false)
        expect(result.errors).to include('Validation failed: ')
      end
    end
  end
end
