class Admin::CategoriesController < Admin::BaseController
  include AdminControllerConcern

  private

  def model_class
    Category
  end

  def permitted_params
    params.require(:category).permit(:name)
  end
end