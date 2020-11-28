require 'rails/source_annotation_extractor'

desc "Enumerate all commonly known annotation"
task :enum => "notes"

namespace :enum do
  ["OPTIMIZE", "FIXME", "TODO"].each do |annotation|
    desc "Enumerate all specific #{annotation.downcase} annotation"
    task annotation.downcase.intern => "notes:#{annotation.downcase}"
  end

  desc "Enumerate all custom annotation \e[1mANNOTATION\e[0m"
  task :custom => "notes:custom"
end

#desc "Enumerate all commonly known annotation"
task :notes do
  SourceAnnotationExtractor.enumerate "OPTIMIZE|FIXME|TODO", :tag => true
end

namespace :notes do
  ["OPTIMIZE", "FIXME", "TODO"].each do |annotation|
    #desc "Enumerate all specific #{annotation.downcase} annotation"
    task annotation.downcase.intern do
      SourceAnnotationExtractor.enumerate annotation
    end
  end

  #desc "Enumerate all custom annotation \e[1mANNOTATION\e[0m"
  task :custom do
    SourceAnnotationExtractor.enumerate ENV['ANNOTATION']
  end
end
