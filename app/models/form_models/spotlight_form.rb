class FormModels::SpotlightForm

  include ActiveModel::Model

  attr_accessor :term, :state

  attr_accessor :items

  def items_attributes=(attributes)
    @items ||= []
    attributes.each do |i, contact_params|
      s = contact_params[:id].present? ? Spotlight.find(contact_params[:id]) : Spotlight.new
      s.assign_attributes(contact_params.slice(:spotlightable_type, :spotlightable_id) )
      s.position = i
      @items.push(s)
    end
  end
end