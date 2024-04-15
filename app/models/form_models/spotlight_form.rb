class FormModels::SpotlightForm

  include ActiveModel::Model

  attr_accessor :term, :state

  attr_accessor :items

  def max
    12
  end

  def items_attributes=(attributes)
    @items ||= []
    attributes.each do |i, contact_params|
      s = contact_params[:id].present? ? Spotlight.find(contact_params[:id]) : Spotlight.new
      s.assign_attributes(contact_params.slice(:spotlightable_type, :spotlightable_id) )
      s.position = i
      # s.mark_for_destruction = true if contact_params[:_destroy] == "1"
      if contact_params[:_destroy] == "1"
        s.destroy if s.persisted?
      else
        @items.push(s) 
      end
    end
  end
end