Rails.application.routes.draw do
  namespace :api do
    resources :forms do
      resources :form_submissions, only: %i[create index]
    end

    resources :form_submissions, param: :qrcode_id, only: [:show] do
      member do
        patch :check_in
      end
    end
  end
end
