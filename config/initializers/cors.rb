# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://schema-frontend.docai.net', 'hku-iday-mo-2024.konnec.ai', 'http://localhost:3002', 'http://localhost:3000',
            'http://localhost:8080', 'http://localhost:8889', 'http://localhost:8888',
            'https://docai-event-x-frontend-dev.vercel.app', 'http://localhost:3001'

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: [:Authorization]
  end
end
