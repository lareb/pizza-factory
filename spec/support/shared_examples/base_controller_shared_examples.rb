# frozen_string_literal: true

RSpec.shared_examples 'a protected vendor controller' do
  context 'when authentication fails' do
    before do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'credentials')
      get :index
    end

    it 'responds with unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when authentication succeeds' do
    before do
      vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
      vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
      get :index
    end

    it 'allows access to the controller action' do
      expect(response).not_to have_http_status(:unauthorized)
    end
  end
end
