module Admin
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
      attr_reader :name, :options, :columns, :filters, :actions, :form_fields

      def initialize(name, options = {})
        @name = name
        @options = options
        @columns = []
        @filters = []
        @actions = []
        @form_fields = []
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