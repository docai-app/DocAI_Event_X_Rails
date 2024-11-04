module Api
  module Admin
    class FormSubmissionsController < ApplicationController
      include AdminAuthenticator
      before_action :set_form_submission, only: %i[show check_in cancel_check_in]

      # GET /api/admin/form_submissions/:qrcode_id
      def show
        render json: { success: true, form_submission: @form_submission }
      end

      # PATCH /api/admin/form_submissions/:qrcode_id/check_in
      def check_in
        if @form_submission.checked_in?
          render json: { success: false, message: '已經簽到過' }, status: :unprocessable_entity
        elsif @form_submission.update(checked_in: true, check_in_at: DateTime.current)
          render json: { success: true, message: '簽到成功' }, status: :ok
        else
          render json: { success: false, errors: @form_submission.errors }, status: :unprocessable_entity
        end
      end

      # PATCH /api/admin/form_submissions/:qrcode_id/cancel_check_in
      def cancel_check_in
        unless @form_submission.checked_in?
          render json: { success: false, message: '尚未簽到' }, status: :unprocessable_entity
          return
        end

        if @form_submission.update(checked_in: false)
          render json: { success: true, message: '取消簽到成功' }, status: :ok
        else
          render json: { success: false, errors: @form_submission.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_form_submission
        @form_submission = FormSubmission.find_by(qrcode_id: params[:qrcode_id])
        render json: { success: false, error: '未找到相關提交' }, status: :not_found unless @form_submission
      end
    end
  end
end
