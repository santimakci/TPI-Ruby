namespace :log do
  desc "Truncate all file in log directory to be empty"
  task :clear do
    FileList["tmp/yankers/*.log"].each do |log_file|
      f = File.open(log_file, "w")
      f.close
    end
  end
end
