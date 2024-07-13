class Admin::CategoriesController < Backstage::BaseController

  private

  def model_class
    Category
  end

  def permitted_params
    params.require(:category).permit(:name)
  end
end