#namespace :resque do
#  desc "TODO"
#  task setup: :environment do
#  end
#end


require "resque/tasks"
require "resque/scheduler/tasks"

task "resque:setup" => :environment do
	ENV["QUEUE"] = "*"
end
