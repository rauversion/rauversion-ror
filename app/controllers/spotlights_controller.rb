class SpotlightsController < ApplicationController

  def edit
    @edit = true
    @edit = false if params[:cancel]
    @user = current_user
    @spotlights = current_user.spotlights.order('position')
    @form = FormModels::SpotlightForm.new
    @form.items = @spotlights 
  end

  def create
    @edit = true
    @form = FormModels::SpotlightForm.new(items: [])

    
    if params[:state].present?
      resource = Track.find(params[:state])
      @form.items << Spotlight.new(spotlightable: resource)
    end

    if params.dig(:form_models_spotlight_form , :items_attributes).present?
      @form.assign_attributes(items_attributes: params[:form_models_spotlight_form][:items_attributes].permit!)
    end

    if params[:commit] == "Save"
      #current_user.spotlights.destroy_all
      @form.items.each do |item|
        item.user_id = current_user.id
        item.save
      end

      # render "create"
    end
 
    render "edit"
  end
end
