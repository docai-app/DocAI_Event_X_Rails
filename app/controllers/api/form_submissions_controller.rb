module Api
  class FormSubmissionsController < ApplicationController
    before_action :set_form_submission, only: %i[show update destroy resend_confirmation_email]

    # GET /api/form_submissions
    def index
      @form_submissions = FormSubmission.all
      render json: { success: true, form_submissions: @form_submissions }
    end

    # GET /api/form_submissions/:id
    def show
      render json: { success: true, form_submission: @form_submission }
    end

    # POST /api/form_submissions
    def create
      @form_submission = FormSubmission.new(submission_params)

      if @form_submission.save
        render json: { success: true, form_submission: @form_submission }, status: :created
      else
        render json: { success: false, errors: @form_submission.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/form_submissions/:id
    def update
      if @form_submission.update(submission_params)
        render json: { success: true, form_submission: @form_submission }
      else
        render json: { success: false, errors: @form_submission.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/form_submissions/:id
    def destroy
      @form_submission.destroy
      render json: { success: true, message: 'Form submission deleted successfully' }, status: :ok
    end

    # GET /api/form_submissions/form/:form_id
    def index_by_form
      @form_submissions = FormSubmission.where(form_id: params[:form_id]).all.order(created_at: :desc)
      @form_submissions = Kaminari.paginate_array(@form_submissions).page(params[:page]).per(50)
      render json: { success: true, form_submissions: @form_submissions, meta: pagination_meta(@form_submissions) }
    end

    def resend_confirmation_email
      # 强制重新发送邮件，无需检查 confirmation_email_sent
      FormSubmissionMailer.confirmation_email(@form_submission.id).deliver_later
      render json: { message: 'Confirmation email has been resent.' }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Form submission not found.' }, status: :not_found
    end

    private

    def set_form_submission
      @form_submission = FormSubmission.find(params[:id])
      render json: { success: false, error: 'Not Found' }, status: :not_found unless @form_submission
    end

    def submission_params
      params.require(:form_submission).permit(:form_id, submission_data: {})
    end

    def pagination_meta(object)
      {
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end
  end
end
