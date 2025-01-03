# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    # 普通用戶只能查看表單
    resources :forms, only: %i[index show]

    namespace :admin do
      # 管理員可以完整操作表單
      resources :forms

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
