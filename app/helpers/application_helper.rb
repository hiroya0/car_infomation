module ApplicationHelper
    def url_to_hash(url)
        Digest::SHA256.hexdigest(url)[0..15] 
     end
end
