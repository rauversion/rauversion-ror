class Backstage::Rails::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_resource_config
  helper_method :resource_class
  before_action :set_resource_scope
  before_action :set_filter_form
  helper_method :resource_class
  before_action :set_resource, only: [:show, :edit, :update, :destroy]


  def indexxx
    @q = @resources.ransack(params[:q])
    @resources = @q.result.page(params[:page])
  end

  def index
    @filter_form = Backstage::Rails::FilterForm.new(filter_params)
    
    #ransack_params = build_ransack_params(@filter_form)

    # @q = resource_class.ransack(ransack_params)
    # @q = resource_class.ransack(ransack_params[:conditions], combinator: ransack_params[:combinator])
    # @resources = @q.result
    
    @resources = apply_filters(resource_class, @filter_form.filter_items)

    @resources = resource_class if @resources.blank?

    # @resources = @filter_form.apply_scope(@resources) if @filter_form.scope.present?
    @resources = @resources.page(params[:page]).per(10) # Adjust per-page as needed
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

  def add_filter
    @resource = Backstage::Rails::Config.resources[controller_name.to_sym]
    @index = @filter_form.filter_items.size + 1
  end

  private

  def build_ransack_params(filter_form)
    return {} if filter_form.filter_items.blank?
  
    groupings = filter_form.filter_items.map.with_index do |item, index|
      next if item.field.blank? || item.operator.blank?
  
      condition = { "#{item.field}_#{item.operator}" => item.value }
      
      if index == 0
        { m: 'or', condition => condition }
      else
        { m: item.condition.downcase, condition => condition }
      end
    end.compact
  
    { g: groupings }
  end

  def set_filter_form
    @filter_form = Backstage::Rails::FilterForm.new(filter_params)
  end

  def filter_params
    params.fetch(:filter_form, {}).permit(
      :scope, 
      :filter_combine, 
      filter_items_attributes: [:field, :operator, :value, :condition]
    )
  end

  def default_render
    if lookup_context.template_exists?(action_name, "admin/#{controller_name}", true)
      super
    else
      render template: "backstage/rails/default/#{action_name}"
    end
  end

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.is_admin?
  end

  def set_resource_config
    @resource_config = Backstage::Rails::Config.resources[controller_name.to_sym]
  end

  def set_resource_scope
    return unless @resource_config

    scope = params[:scope]&.to_sym
    @resources = resource_class.all

    if scope
      scope_config = @resource_config.scopes.find { |s| s[:name] == scope }
      if scope_config
        @resources = if scope_config[:lambda]
                       resource_class.instance_exec(&scope_config[:lambda])
                     elsif scope == :all
                       resource_class.all
                     else
                       resource_class.send(scope)
                     end
      end
    end

    @resources = @resources.page(params[:page]).per(10) # Adjust per-page as needed
  end

  def resource_class
    @resource_class ||= controller_name.classify.constantize
  end

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


  def apply_filters(relation, filter_items)
    return relation if filter_items.blank?
  
    table = relation.arel_table
    conditions = filter_items.inject(nil) do |cond, item|
      next cond if item.field.blank? || item.operator.blank? #|| item.value.blank?
  
      new_condition = build_arel_condition(table, item)
      if cond.nil?
        new_condition
      else
        item.condition&.downcase == 'or' ? cond.or(new_condition) : cond.and(new_condition)
      end
    end
  
    relation.where(conditions) if conditions
  end
  
  def build_arel_condition(table, item)
    column = table[item.field]
    case item.operator
    when 'eq'
      column.eq(item.value)
    when 'not_eq'
      column.not_eq(item.value)
    when 'matches'
      column.matches("%#{item.value}%")
    when 'gt'
      column.gt(item.value)
    when 'lt'
      column.lt(item.value)
    when 'gteq'
      column.gteq(item.value)
    when 'lteq'
      column.lteq(item.value)
    else
      raise "Unsupported operator: #{item.operator}"
    end
  end
  
end