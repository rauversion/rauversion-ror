class Admin::TermsAndConditionsController < Backstage::BaseController

  private

  def model_class
    TermsAndCondition
  end

  def permitted_params
    params.require(:terms_and_condition).permit(:title, :category, :content)
  end
end