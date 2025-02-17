# frozen_string_literal: true

module Vendors
  # BaseController
  class BaseController < ApplicationController
    before_action :authenticate_vendor

    private

    def authenticate_vendor
      vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
      vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)

      authenticate_or_request_with_http_basic('Vendor Area') do |username, password|
        username == vendor_username && password == vendor_password
      end
    end
  end
end
