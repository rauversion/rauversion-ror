class ArticlesController < ApplicationController

  def index
    @articles = Post.published.all
  end

  def new
    @article = current_user.posts.new
  end

  def show
    @post = Post.published.friendly.find(params[:id])

    set_meta_tags(
      title: @post.title,
      description: @post.excerpt,
      keywords: "",
      # url: Routes.articles_show_url(socket, :show, post.id),
      title: "#{@post.title} on Rauversion",
      description: "Read #{@post.title} by #{@post.user.username} on Rauversion.",
      image: @post.cover_url(:small)
    )
  end

  def create
    @article = current_user.posts.create(body: params[:post][:body])
    redirect_to edit_article_path(@article), status: :see_other
  end

  def edit
    @article = current_user.posts.friendly.find(params[:id])
    # redirect_to edit_article_path(@article)
  end

  def update
    @article = current_user.posts.friendly.find(params[:id])
    @article.update(article_params)
    # redirect_to edit_article_path(@article)
    flash.now[:notice] = "aloha!!"
  end

  def mine
    @posts = current_user.posts
    @tab = params[:tab] || "all"
  end

  private

  def article_params
    params.require(:post).permit(
      :id, :title, :private, 
      :category_id, :state, :excerpt, body: {}
    )
  end
end
