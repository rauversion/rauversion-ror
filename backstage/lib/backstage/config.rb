module Backstage
  class Config
    class << self

      attr_accessor :current_user_method
      attr_reader :authenticate_admin_block

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

      def current_user_method
        @current_user_method || :current_user
      end

      def authenticate_admin(&block)
        @authenticate_admin_block = block
      end

      def ensure_controller_exists(resource_name)
        controller_name = "Backstage::#{resource_name.to_s.classify.pluralize}Controller"
        unless Object.const_defined?(controller_name)
          Rails::Generators.invoke("backstage:controller", [resource_name.to_s])
        end
      end
      
    end

    class Resource
      attr_reader :name, :options, :columns, :filters, 
      :actions, :form_fields, :scopes, :filterable_fields, 
      :custom_actions, :controller_name

      def initialize(name, options = {})
        @name = name
        @options = options
        @columns = []
        @filters = []
        @actions = []
        @form_fields = []
        @scopes = []
        @filterable_fields = []
        @custom_actions = []
        @controller_name = options[:controller] || "backstage/#{name.to_s.pluralize}"
        # Backstage::Config.ensure_controller_exists(name)
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

      def custom_action(name, options = {}, &block)
        @custom_actions << {
          name: name,
          options: options,
          block: block
        }
      end
    end
  end
end