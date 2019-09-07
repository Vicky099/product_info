require 'sidekiq'
require 'sidekiq/web'
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
	[user, password] == ["admin", "admin123!"]
end
Sidekiq.configure_server do |config|
	config.redis = AppConfig.redis
end

Sidekiq.configure_client do |config|
	config.redis = AppConfig.redis
end

#Sidekiq.hook_rails!
#Sidekiq.remove_delay!

