namespace :tmp do
  ###desc "Clear sessions, caches, and linkages files from tmp/ (narrow w/ tmp:session:clear, tmp:cache:clear, tmp:linkage:clear)"
  desc "Clear application temporary resource"
  task :clear => [ "tmp:session:clear",  "tmp:cache:clear", "tmp:linkage:clear"]

  desc "Create application temporary resource"
  task :create do
    FileUtils.mkdir_p(%w( tmp/sessions tmp/caches tmp/linkages tmp/events tmp/caches/raia ))
  end

  namespace :session do
    # desc "Clears all files in tmp/sessions"
    task :clear do
      FileUtils.rm(Dir['tmp/sessions/[^.]*'])
    end
  end

  namespace :cache do
    # desc "Clears all files and directories in tmp/caches"
    task :clear do
      FileUtils.rm_rf(Dir['tmp/caches/[^.]*'])
    end
  end

  namespace :linkage do
    # desc "Clears all files in tmp/linkages"
    task :clear do
      FileUtils.rm(Dir['tmp/linkages/[^.]*'])
    end
  end

  namespace :event do
    # desc "Clears all files in tmp/events"
    task :clear do
      FileUtils.rm(Dir['tmp/events/[^.]*'])
    end
  end
end
