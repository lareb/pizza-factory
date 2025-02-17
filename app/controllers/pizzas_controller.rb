# frozen_string_literal: true

# PizzasController
class PizzasController < ApplicationController
  def index
    @pizzas = Pizza.includes(:category).page(params[:page]).per(PER_PAGE).order(created_at: :desc)
  end
end
