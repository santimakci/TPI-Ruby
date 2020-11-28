$VERBOSE = nil

# Load Rails rakefile extensions
%w(
  annotations
  documentation
  framework
  log
  middleware
  misc
  routes
  statistics
  tmp
).each do |task|
  load "rails/tasks/#{task}.rake"
end

# Delete task to be overridden
['assets:clean', 'assets:clean:all', 'assets:environment', 'assets:precompile', 'assets:precompile:all', 'assets:precompile:nondigest', 'assets:precompile:primary'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}
['db:_dump', 'db:abort_if_pending_migrations', 'db:charset', 'db:collation', 'db:create', 'db:create:all', 'db:drop', 'db:drop:all', 'db:fixtures:identify', 'db:fixtures:load', 'db:forward', 'db:load_config', 'db:migrate', 'db:migrate:down', 'db:migrate:redo', 'db:migrate:reset', 'db:migrate:status', 'db:migrate:up', 'db:reset', 'db:rollback', 'db:schema:dump', 'db:schema:load', 'db:schema:load_if_ruby', 'db:seed', 'db:sessions:clear', 'db:sessions:create', 'db:setup', 'db:structure:dump', 'db:structure:load', 'db:structure:load_if_sql', 'db:test:clone', 'db:test:clone_structure', 'db:test:load', 'db:test:load_schema', 'db:test:load_structure', 'db:test:prepare', 'db:test:purge', 'db:version'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}
['dropbox:authorize'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}
['erd', 'erd:generate', 'erd:load_models', 'erd:options'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}
['paperclip:clean', 'paperclip:refresh', 'paperclip:refresh:metadata', 'paperclip:refresh:missing_styles', 'paperclip:refresh:thumbnails'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}
['spec', 'spec:statsetup', 'spec:servants', 'spec:helpers', 'spec:lib', 'spec:mailers', 'spec:models', 'spec:rcov', 'spec:requests', 'spec:routing', 'spec:displays'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}

# Delete task to be deleted
['test', 'test:recent', 'test:single', 'test:uncommitted'].each{|removable_task| Rake.application.instance_variable_get('@tasks').delete(removable_task)}

# Load new custom task
load "rails/custom/asset.rake"
load "rails/custom/database.rake"
load "rails/custom/dropbox.rake"
load "rails/custom/erd.rake"
load "rails/custom/paperclip.rake"
load "rails/custom/spec.rake"
