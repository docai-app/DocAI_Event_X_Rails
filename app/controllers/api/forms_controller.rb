module Api
  class FormsController < ApplicationController
    before_action :set_form, only: %i[show update destroy]

    # POST /api/forms
    def create
      @form = Form.new(form_params)

      if @form.save
        render json: @form, status: :created
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end

    # GET /api/forms/:id
    def show
      render json: @form
    end

    # GET /api/forms
    def index
      @forms = Form.all
      render json: @forms
    end

    # PATCH/PUT /api/forms/:id
    def update
      if @form.update(form_params)
        render json: @form
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/forms/:id
    def destroy
      @form.destroy
      head :no_content
    end

    private

    def set_form
      @form = Form.find(params[:id])
    end

    def form_params
      params.require(:form).permit(:name, :description, :structure)
    end
  end
end
