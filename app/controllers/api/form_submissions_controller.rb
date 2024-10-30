module Api
  class FormSubmissionsController < ApplicationController
    before_action :set_form_submission, only: %i[show check_in]

    # GET /api/form_submissions/:id
    def show
      render json: { success: true, form_submission: @form_submission }
    end

    # POST /api/form_submissions
    def create
      @form_submission = FormSubmission.new(submission_params)

      if @form_submission.save
        qr = RQRCode::QRCode.new(@form_submission.qrcode_id.to_s)
        svg = qr.as_svg(
          offset: 0,
          color: '000',
          shape_rendering: 'crispEdges',
          module_size: 6
        )
        render json: { success: true, form_submission: @form_submission }, status: :created
      else
        render json: { success: false, errors: @form_submission.errors }, status: :unprocessable_entity
      end
    end

    private

    def set_form_submission
      @form_submission = FormSubmission.find_by(qrcode_id: params[:qrcode_id])
      render json: { success: false, error: 'Not Found' }, status: :not_found unless @form_submission
    end

    def submission_params
      params.require(:form_submission).permit(:form_id, submission_data: {})
    end
  end
end
