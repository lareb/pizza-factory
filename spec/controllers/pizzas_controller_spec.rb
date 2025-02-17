# frozen_string_literal: true

# spec/controllers/pizzas_controller_spec.rb
require 'rails_helper'

RSpec.describe PizzasController, type: :controller do
  let!(:pizzas) do
    create(:pizza, name: 'Barbecue Ribs')
    create(:pizza, name: 'Mushroom Risotto')
    create(:pizza, name: 'Pasta with Tomato and Basil')
    create(:pizza, name: 'Margherita')
    create(:pizza, name: 'Pepperoni')
  end

  describe 'GET #index' do
    it 'assigns @pizzas and renders the index template' do
      get :index

      expect(assigns(:pizzas).pluck(:name)).to match_array(['Barbecue Ribs', 'Mushroom Risotto',
                                                            'Pasta with Tomato and Basil', 'Margherita', 'Pepperoni'])

      expect(response).to render_template(:index)
    end

    it 'paginates the pizzas' do
      get :index, params: { page: 1 }

      expect(assigns(:pizzas).total_count).to eq(5)  # Ensure pagination works correctly with 5 pizzas
      expect(assigns(:pizzas).current_page).to eq(1)
    end
  end
end
