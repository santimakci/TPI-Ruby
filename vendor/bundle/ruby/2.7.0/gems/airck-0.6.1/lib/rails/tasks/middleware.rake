desc 'Print out all rack middleware stack'
task :middleware => :environment do
  Rails.configuration.middleware.each do |middleware|
    puts "use #{middleware.inspect}"
  end
  puts "run #{Rails.application.class.name}.routes"
end
