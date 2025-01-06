# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    # 普通用戶只能查看表單
    resources :forms, only: %i[index show]

    resources :form_submissions, only: [:create] do
      member do
        post :resend_confirmation_email
        patch :check_in
      end
      collection do
        get 'form/:form_id/search', action: :search_by_form
      end
    end

    namespace :admin do
      # 管理員可以完整操作表單
      resources :forms do
        resource :email_template, only: %i[show update]
      end

      # 保留原有的 form_submissions 路由
      resources :form_submissions, param: :qrcode_id, only: [:show] do
        member do
          patch :check_in
          patch :cancel_check_in
        end
      end
    end
  end
end
