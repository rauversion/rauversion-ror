module Backstage
  class Config
    class << self
      def configure(&block)
        class_eval(&block)
      end

      def resource(name, options = {}, &block)
        resource = Resource.new(name, options)
        resource.instance_eval(&block) if block_given?
        resources[name] = resource
      end

      def resources
        @resources ||= {}
      end
    end

    class Resource
      attr_reader :name, :options, :columns, :filters, 
      :actions, :form_fields, :scopes, :filterable_fields

      def initialize(name, options = {})
        @name = name
        @options = options
        @columns = []
        @filters = []
        @actions = []
        @form_fields = []
        @scopes = []
        @filterable_fields = []
      end

      def filterable_field(name, type, options = {})
        @filterable_fields << { name: name, type: type, options: options }
      end

      def scope(name, lambda = nil, options = {})
        if lambda.is_a?(Hash)
          options = lambda
          lambda = nil
        end
        @scopes << { name: name, lambda: lambda, options: options }
      end

      def form_field(name, type, options = {})
        @form_fields << { name: name, type: type, options: options }
      end

      def column(name, options = {}, &block)
        @columns << { name: name, options: options, block: block }
      end

      def filter(name, type, options = {})
        @filters << { name: name, type: type, options: options }
      end

      def action(name, options = {})
        @actions << { name: name, options: options }
      end
    end
  end
end