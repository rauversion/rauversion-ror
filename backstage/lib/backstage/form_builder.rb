module Backstage
  class FormBuilder < ActionView::Helpers::FormBuilder
    def generate_fields(resource)
      fields = resource.form_fields.map do |field|
        if field[:type] == :custom
          field[:options].call(@template, self)
        else
          send("#{field[:type]}_field", field[:name], field[:options])
        end
      end
      fields.join.html_safe
    end

    private

    def string_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      text_field(name, class: input_classes)
    end

    def boolean_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      check_box_field(name, class: input_classes)
    end

    def text_area_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      text_area(name, class: input_classes)
    end

    def check_box_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      check_box(name, class: input_classes)
    end

    def email_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      super(name, class: input_classes)
    end

    def select_field(name, options)
      label(name, options[:label] || name.to_s.titleize) +
      select(name, options[:collection].call, { include_blank: options[:include_blank] }, class: input_classes)
    end

    def input_classes
      "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
    end
  end
end