# frozen_string_literal: true

module Api
  class FormsController < ApplicationController
    # GET /api/forms/:id
    def show
      @form = Form.find(params[:id])
      render json: { success: true, form: @form }
    end

    # GET /api/forms
    def index
      @forms = if params[:status] == 'active'
                 Form.active
               elsif params[:status] == 'inactive'
                 Form.inactive
               else
                 Form.all
               end
      render json: { success: true, forms: @forms }
    end
  end
end
