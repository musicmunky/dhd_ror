json.array!(@posts) do |post|
  json.extract! post, :id, :author, :create_date_gmt, :update_date_gmt, :title, :content, :name, :status, :live_date, :guid
  json.url post_url(post, format: :json)
end
