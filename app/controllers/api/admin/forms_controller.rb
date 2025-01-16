module Api
  module Admin
    class FormsController < ApplicationController
      include AdminAuthenticator
      before_action :set_form, only: %i[show update destroy]

      # GET /api/admin/forms
      def index
        @forms = Form.all.order(created_at: :desc)
        render json: { success: true, forms: @forms }
      end

      # GET /api/admin/forms/:id
      def show
        render json: { success: true, form: @form }
      end

      # POST /api/admin/forms
      def create
        @form = Form.new(form_params)

        if @form.save
          render json: { success: true, form: @form }, status: :created
        else
          render json: { success: false, errors: @form.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/admin/forms/:id
      def update
        if @form.update(form_params)
          render json: { success: true, form: @form }
        else
          render json: { success: false, errors: @form.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/admin/forms/:id
      def destroy
        @form.destroy
        render json: { success: true, message: '表單已成功刪除' }, status: :ok
      end

      private

      def set_form
        @form = Form.find(params[:id])
      end

      def form_params
        params.require(:form).permit(
          :name,
          :description,
          :is_active,
          :email_enabled,
          meta: {
            display: %i[title description]
          },
          display_order: [],
          json_schema: {},
          ui_schema: {},
          form_data: {},
          email_template_attributes: [
            :id,
            :name,
            :subject,
            :html_content,
            { placeholders: [] }
          ]
        )
      end
    end
  end
end
