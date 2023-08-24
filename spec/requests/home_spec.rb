require 'rails_helper'

RSpec.describe "Homes", type: :request do

  describe "GET /" do
    it "sets the locale based on the locale parameter" do
      get root_path(locale: :es)
      expect(I18n.locale).to eq(:es)
    end

    it "sets the locale based on the locale cookie if no parameter is passed" do
      cookies[:locale] = :es
      get root_path
      expect(I18n.locale).to eq(:es)
    end

    it "sets the locale to the default locale if no parameter or cookie is present" do
      get root_path
      expect(I18n.locale).to eq(I18n.default_locale)
    end

    it "stores the locale in a cookie if a parameter is passed" do
      get root_path(locale: :es)
      expect(cookies[:locale]).to eq("es")
    end
  end
end
