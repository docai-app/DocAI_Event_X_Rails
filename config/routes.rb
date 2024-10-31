Rails.application.routes.draw do
  namespace :api do
    resources :forms, only: %i[create show update destroy index]

    resources :form_submissions, only: %i[index show create update destroy] do
      collection do
        get 'form/:form_id', to: 'form_submissions#index_by_form', as: 'by_form'
      end
    end

    namespace :admin do
      resources :form_submissions, param: :qrcode_id, only: [:show] do
        member do
          patch :check_in
        end
      end
    end
  end
end
