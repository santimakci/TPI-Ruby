require 'active_record/connection_adapters/abstract/schema_statements'

ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def format_and_minify(text, max = 30)
    result = text
    while (result.length > 30)
      result = result.split('_').map{|segment| segment.eql?('idx') ? segment : segment[0..-2]}.join('_').gsub('______', '_').gsub('_____', '_').gsub('____', '_').gsub('___', '_').gsub('__', '_')
    end
    result
  end

  def format_and_simplify(text, mode = :first)
    result = text
    if mode.eql?(:first)
      result = result.to_s.downcase.gsub('_id', '').split('_').map{|segment| segment.singularize}.map{|segment| (segment.length > 5) ? (segment[0..1] + segment[segment.length / 2] + segment[(segment.length - 2)..(segment.length - 1)]) : segment}.join('_')
    elsif mode.eql?(:second)
      result = result.to_s.downcase.gsub('_id', '').gsub('a', '').gsub('e', '').gsub('i', '').gsub('o', '').gsub('u', '').split('_').map{|segment| (segment.length > 4) ? segment[0..4] : segment}.join('_')
    end
    result
  end

  def index_name(table_name, options) #:nodoc:
    if Hash === options # legacy support
      if options[:column]
        # === DEFAULT
        # "index_#{table_name}_on_#{Array.wrap(options[:column]) * '_and_'}"
        # === DEFAULT
        ref_id = []
        ref_type = []
        ref_poly = []
        Array.wrap(options[:column]).map{|x| x.to_s.downcase}.each{|x| ref_id << x if x.include?('_id'); ref_type << x if x.include?('_type');}
        ref_type.each{|x| ref_poly << x if ref_id.include?(x.gsub('_type', '_id'))}
        used_cols = []
        Array.wrap(options[:column]).map{|x| x.to_s.downcase}.each{|x| used_cols << format_and_simplify(x) unless ref_poly.include?(x)}
        format_and_minify("idx_#{format_and_simplify(table_name)}_#{used_cols.join('_')}")
      elsif options[:name]
        options[:name]
      else
        raise ArgumentError, "You must specify the index name"
      end
    else
      index_name(table_name, :column => options)
    end
  end
end
