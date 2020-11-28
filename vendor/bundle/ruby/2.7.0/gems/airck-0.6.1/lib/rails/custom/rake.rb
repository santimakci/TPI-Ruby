#class Rake::Task
#  p 'over'
#  def overwrite(&block)
#    p 'overwrite'
#    @actions.try(:clear)
#    enhance(&block)
#  end
#  def override(&block)
#    p 'override'
#    @setups.try(:clear)
#    enhance(&block)
#  end
#end

#Rake::Task['db:schema:dump'].override do
#  p 'db:schema:dump'
#  File.open(Rails.root.to_s + '/data/structures/schema.tmp', 'w') do |new_schema_content|
#    if false
#      new_schema_content.puts('## This schema file is automatically generated from the current state of the database')
#      new_schema_content.puts('## Instead of editing this file, please use the migrations feature of active record')
#      new_schema_content.puts('## Note that this schema definition is the authoritative source for the database schema')
#      new_schema_content.puts('## Please use db:schema:load task to create the application database on another system')
#      new_schema_content.puts('## The more migrations provided, the slower for runtime and the greater for issues')
#      new_schema_content.puts('## This file is strongly recommended to be included into the version control system')
#    end
#    File.open(Rails.root.to_s + '/data/structures/schema.rb', 'r') do |old_schema_content|
#      replacements = [[/(,)\s+/, ', '], ['"', '\''], [':version =>', 'version:'], [':force =>', 'force:'], [':null =>', 'null:'], [':name =>', 'name:']]
#      old_schema_content.each_line.with_index do |line, index|
#        new_schema_content.puts((replacements.each{|replacement| line = line.gsub(replacement.first, replacement.last)}; line)) if index > 12
#      end
#    end
#  end
#  File.delete(Rails.root.to_s + '/data/structures/schema.rb')
#  File.rename(Rails.root.to_s + '/data/structures/schema.tmp', Rails.root.to_s + '/data/structures/schema.rb')
#end

#Rake::Task['db:schema:load'].overwrite do
#  p 'db:schema:load'
#  schema_file_path = Rails.root.to_s + '/data/structures/schema.rb'
#  load(schema_file_path) if File.exist?(schema_file_path)
#end

#Rake::Task['db:seed'].overwrite do
#  p 'db:seed'
#  content_file_path = Rails.root.to_s + '/data/structures/content.rb'
#  load(content_file_path) if File.exist?(content_file_path)
#end

#Rake::Task['assets:precompile'].overwrite do
#  p 'assets:precompile'
#  System.runtime('rake', 'assets:precompile:all RAILS_ENV=production RAILS_GROUPS=assets')
#  unless Rails.env.eql?('production')
#    File.rename(Rails.root.to_s + '/ref/worlds/manifest.yml', Rails.root.to_s + '/ref/worlds/manifest.tmp')
#    File.open(Rails.root.to_s + '/ref/worlds/manifest.yml', 'w') do |new_manifest_content|
#      File.open(Rails.root.to_s + '/ref/worlds/manifest.tmp', 'r') do |old_manifest_content|
#        old_manifest_content.each_line.with_index do |line, index|
#          new_manifest_content.puts(line) if index > 0
#        end
#      end
#    end
#    File.delete(Rails.root.to_s + '/ref/worlds/manifest.tmp')
#  end
#  General.writer(:instance)
#end
