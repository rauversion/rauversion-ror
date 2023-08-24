class ErrorsController < ApplicationController
  layout "errors"

  def not_found
    render "404"
  end

  def fatal
    render "500"
  end

  def not_allowed
    render "422"
  end
end
