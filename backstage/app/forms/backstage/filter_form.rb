# app/forms/admin_filter_form.rb
class Backstage::FilterForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  # include ActiveModel::NestedAttributes

  attribute :scope, :string
  #attribute :filter_combine, :string, default: 'AND'

  #validates :scope, presence: true
  #validates :filter_combine, inclusion: { in: %w[AND OR] }

  attr_accessor :filter_items

  def initialize(attributes = {})
    super
    self.filter_items = [] if filter_items.nil?
    self.filter_items << Backstage::FilterFormItem.new if filter_items.empty?
  end

  def filter_items_attributes=(attributes)
    self.filter_items = attributes.values.map { |attrs| Backstage::FilterFormItem.new(attrs) }
  end

  def add_filter_item
    filter_items << Backstage::FilterFormItem.new
  end

  def apply(relation)
    scope_relation = apply_scope(relation)
    apply_filters(scope_relation)
  end

  def apply_scope(relation)
    return relation if scope.blank?

    if relation.respond_to?(scope)
      relation.public_send(scope)
    else
      relation
    end
  end

  private

  def apply_filters(relation)
    return relation if filter_items.empty?

    filter_items.inject(relation) do |result, filter|
      next result if filter.field.blank? || filter.operator.blank? || filter.value.blank?

      condition = filter.condition&.downcase&.to_sym || :and
      query = { filter.field => { filter.operator => filter.value } }

      result.ransack({ condition => query }).result
    end
  end
end


# app/models/admin_filter_form_item.rb
class Backstage::FilterFormItem
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :field, :string
  attribute :operator, :string
  attribute :value, :string
  attribute :condition, :string, default: 'AND'

  validates :field, :operator, presence: true
end