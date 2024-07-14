class TermsAndConditionsController < ApplicationController
  def index
    @terms = if params[:category]
               TermsAndCondition.where(category: params[:category])
             else
               TermsAndCondition.all
             end
  end

  def show
    @term = TermsAndCondition.find(params[:id])
  end
end
