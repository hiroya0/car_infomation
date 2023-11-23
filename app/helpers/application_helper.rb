# frozen_string_literal: true

module ApplicationHelper
  def url_to_hash(url)
    Digest::SHA256.hexdigest(url)[0..15]
  end

  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'success' 
    when 'error'
      'danger'    
    end
  end
end
