module TermsAndConditionsHelper

  def terms_and_conditions_menu
    TermsAndCondition.pluck(:category).uniq.map do |category|
      link_to category.titleize, terms_and_conditions_path(category: category)
    end.join(' | ').html_safe
  end

end
