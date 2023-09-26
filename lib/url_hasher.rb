require 'digest'

module UrlHasher
  def self.to_hash(url)
    Digest::SHA256.hexdigest(url)[0..15] # 16文字のハッシュを取得
  end
end
