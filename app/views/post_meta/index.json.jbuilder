json.array!(@post_meta) do |post_metum|
  json.extract! post_metum, :id, :post_id, :meta_key, :value
  json.url post_metum_url(post_metum, format: :json)
end
