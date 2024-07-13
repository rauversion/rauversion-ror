class Admin::PostsController < Backstage::BaseController

  private

  def model_class
    Post
  end

  def permitted_params
    params.require(:post).permit(:title)
  end
end