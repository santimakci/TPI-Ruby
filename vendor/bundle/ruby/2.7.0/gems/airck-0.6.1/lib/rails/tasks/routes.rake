#desc "Print out all application route \e[1mCONTROLLER\e[0m"
task :routes => :environment do
  Rails.application.reload_routes!
  all_routes = Rails.application.routes.routes

  require 'rails/application/route_inspector'
  inspector = Rails::Application::RouteInspector.new
  puts inspector.format(all_routes, ENV['CONTROLLER']).join "\n"
end

desc "Print out all application route \e[1mCONTROLLER\e[0m"
task :route => "routes"
