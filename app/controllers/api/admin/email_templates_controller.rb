module Api
  module Admin
    class EmailTemplatesController < ApplicationController
      include AdminAuthenticator
      before_action :set_form
      before_action :set_email_template, only: %i[show update destroy]

      def index
        @email_template = @form.email_template
        render json: { success: true, email_template: @email_template }
      end

      def show
        render json: { success: true, email_template: @email_template }
      end

      def create
        @email_template = @form.build_email_template(email_template_params)
        if @email_template.save
          render json: { success: true, email_template: @email_template }, status: :created
        else
          render json: { success: false, errors: @email_template.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @email_template.update(email_template_params)
          render json: { success: true, email_template: @email_template }
        else
          render json: { success: false, errors: @email_template.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @email_template.destroy
        render json: { success: true, message: '郵件模板已刪除' }
      end

      private

      def set_form
        @form = Form.find(params[:form_id])
      end

      def set_email_template
        @email_template = @form.email_template
        render json: { success: false, error: '未找到郵件模板' }, status: :not_found unless @email_template
      end

      def email_template_params
        params.require(:email_template).permit(:name, :subject, :html_content, placeholders: [])
      end
    end
  end
end
