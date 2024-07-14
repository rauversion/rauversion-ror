module ProductPurchasesHelper

  def shipping_status_progress(status)
    statuses = ProductPurchase.shipping_statuses.keys
    current_index = statuses.index(status.to_s)
    total_statuses = statuses.length
    
    return 0 if current_index.nil?
    
    ((current_index + 1).to_f / total_statuses * 100).round
  end

  def shipping_status_class(status, current_status)
    return "" if current_status.blank?
    if ProductPurchase.shipping_statuses[current_status] <= ProductPurchase.shipping_statuses[status]
      "text-indigo-600"
    else
      "text-gray-500"
    end
  end

end
