module AdminControllerConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
  end

  def index
    @q = model_class.ransack(params[:q])
    @resources = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @resource = model_class.new
  end

  def edit
  end

  def create
    @resource = model_class.new(permitted_params)

    if @resource.save
      redirect_to [:admin, @resource], notice: "#{model_class.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @resource.update(permitted_params)
      redirect_to [:admin, @resource], notice: "#{model_class.name} was successfully updated."
    else
      Rails.logger.error(@resource.errors.full_messages)
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to [:admin, model_class], notice: "#{model_class.name} was successfully destroyed."
  end

  private

  def set_resource
    if model_class.respond_to?(:friendly)
      @resource = model_class.friendly.find(params[:id])
    else
      @resource = model_class.find(params[:id])
    end
  end

  def model_class
    raise NotImplementedError, "Subclasses must define model_class"
  end

  def permitted_params
    raise NotImplementedError, "Subclasses must define permitted_params"
  end
end