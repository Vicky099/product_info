require 'sidekiq'
require 'sidekiq/web'
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
	[user, password] == ["admin", "admin123!"]
end
Sidekiq.configure_server do |config|
	config.redis = AppConfig.redis
	Sidekiq::Status.configure_server_middleware config
end

Sidekiq.configure_client do |config|
	config.redis = AppConfig.redis
	Sidekiq::Status.configure_client_middleware config
end

#Sidekiq.hook_rails!
#Sidekiq.remove_delay!

