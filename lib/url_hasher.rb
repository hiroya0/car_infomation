# frozen_string_literal: true

require 'digest'

module UrlHasher
  def self.to_hash(url)
    Digest::SHA256.hexdigest(url)[0..15]
  end
end
