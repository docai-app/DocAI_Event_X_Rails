module Api
  class FormSubmissionsController < ApplicationController
    before_action :set_form, only: [:create]
    before_action :set_form_submission, only: %i[show check_in]

    # POST /api/forms/:form_id/submissions
    def create
      @form_submission = @form.form_submissions.new(submission_params)

      if @form_submission.save
        # 生成 QR Code（假設使用 RQRCode gem）
        qr = RQRCode::QRCode.new(@form_submission.qrcode_id.to_s)
        svg = qr.as_svg(
          offset: 0,
          color: '000',
          shape_rendering: 'crispEdges',
          module_size: 6
        )
        # 在這裡您可以將 QR Code 存儲或通過郵件發送

        render json: @form_submission, status: :created
      else
        render json: @form_submission.errors, status: :unprocessable_entity
      end
    end

    # GET /api/form_submissions/:qrcode_id
    def show
      render json: @form_submission
    end

    # PATCH /api/form_submissions/:qrcode_id/check_in
    def check_in
      if @form_submission.checked_in?
        render json: { message: 'Already checked in' }, status: :unprocessable_entity
      else
        @form_submission.update(checked_in: true)
        render json: { message: 'Check-in successful' }, status: :ok
      end
    end

    private

    def set_form
      @form = Form.find(params[:form_id])
    end

    def set_form_submission
      @form_submission = FormSubmission.find_by(qrcode_id: params[:qrcode_id])
      render json: { error: 'Not Found' }, status: :not_found unless @form_submission
    end

    def submission_params
      params.require(:form_submission).permit(:submission_data)
    end
  end
end
