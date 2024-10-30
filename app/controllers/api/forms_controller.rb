module Api
  class FormsController < ApplicationController
    before_action :set_form, only: %i[show update destroy]

    # POST /api/forms
    def create
      @form = Form.new(form_params)

      if @form.save
        render json: { success: true, form: @form }, status: :created
      else
        render json: { success: false, errors: @form.errors }, status: :unprocessable_entity
      end
    end

    # GET /api/forms/:id
    def show
      render json: { success: true, form: @form }
    end

    # GET /api/forms
    def index
      @forms = Form.all
      render json: { success: true, forms: @forms }
    end

    # PATCH/PUT /api/forms/:id
    def update
      if @form.update(form_params)
        render json: { success: true, form: @form }
      else
        render json: { success: false, errors: @form.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/forms/:id
    def destroy
      @form.destroy
      render json: { success: true, message: 'Form deleted successfully' }, status: :ok
    end

    private

    def set_form
      @form = Form.find(params[:id])
    end

    def form_params
      params.require(:form).permit(:name, :description, json_schema: {}, ui_schema: {}, form_data: {})
    end
  end
end
