# encoding: utf-8

Logger::SimpleFormatter.class_eval do
  def riana_custom_log_message_styler(text)
    minimum = Rails.riana_value_getter('[:logger][:wrap_style]')[0]
    maximum = Rails.riana_value_getter('[:logger][:wrap_style]')[1]
    bold = Rails.riana_value_getter('[:logger][:wrap_style]')[2]
    color = Rails.riana_value_getter('[:logger][:wrap_style]')[3]
    clean = Rails.riana_value_getter('[:logger][:wrap_style]')[4]
    split_mode = :one
    text = text[1..-1] if text[0].eql?(" ")
    text = text.gsub("\n\n\n\n\n","\n").gsub("\n\n\n\n","\n").gsub("\n\n\n","\n").gsub("\n\n","\n").gsub("\n ","\n")
    text = text.gsub("       "," ").gsub("      "," ").gsub("     "," ").gsub("    "," ").gsub("   "," ").gsub("  "," ")
    text = text.gsub("-------","#").gsub("------","#").gsub("-----","#").gsub("----","#").gsub("---","#").gsub("--","#")
    text = text.gsub("#######","#").gsub("######","#").gsub("#####","#").gsub("####","#").gsub("###","#").gsub("##","#")
    mask = {"\e[0m" => "☀","\e[1m" => "☁","\e[30m" => "☂","\e[31m" => "☃","\e[32m" => "☄","\e[33m" => "★","\e[34m" => "☆","\e[35m" => "☇","\e[36m" => "☈","\e[37m" => "☉","\e[38m" => "☊","\e[39m" => "☋","\e[90m" => "☌","\e[91m" => "☍","\e[92m" => "☎","\e[93m" => "☏","\e[94m" => "☔","\e[95m" => "☕","\e[96m" => "☖","\e[97m" => "☗","\e[98m" => "☘","\e[99m" => "☙"}
    mask.each{|key, value| text = text.gsub(key, value).gsub(value + " (", value + "(")}
    replacers = []
    replacers += ["☀"] unless clean
    replacers += ["☁"] unless bold
    replacers += ["☂","☃","☄","★","☆","☇","☈","☉","☊","☋","☌","☍","☎","☏","☔","☕","☖","☗","☘","☙"] unless color
    replacers.each{|replacer| text = text.gsub(replacer, "")}
    if split_mode.eql?(:one)
      segments = text.squish.split.map{|part| part.scan(/.{1,#{maximum}}/).map{|e| e.strip.squish}}.flatten
    elsif split_mode.eql?(:two)
      segments = text.squish.split.map{|part| part.scan(/.{1,#{maximum}}\b|.{1,#{maximum}}/).map{|e| e.strip.squish}}.flatten
    elsif split_mode.eql?(:three)
      segments = text.squish.scan(/.{1,#{maximum}}\b|.{1,#{maximum}}/).map{|e| e.strip.squish}.flatten
    end
    result = ""
    counter = 0
    min_length_for_1 = minimum - 76
    min_length_for_2 = minimum - 64
    min_length_for_3 = minimum - 47
    min_length_for_4 = minimum - 33
    segments.each do |segment|
      if (counter + segment.length + 1 <= maximum)
        result += (counter.eql?(0) ? segment : (" " + segment))
        counter += (counter.eql?(0) ? segment.length : (segment.length + 1))
      else
        result += ((counter.eql?(0) ? '' : "\n") + segment)
        counter = segment.length
      end
    end
    if ((counter < min_length_for_1) and (min_length_for_1 > 0))
      result += (result[-2..-1].eql?(' ☀') ? '' : ' ') + "(Successfully Processed With Some Extra Addition #{Time.now})"
    elsif ((counter < min_length_for_2) and (min_length_for_2 > 0))
      result += (result[-2..-1].eql?(' ☀') ? '' : ' ') + "(Clearly Executed With Specification #{Time.now})"
    elsif ((counter < min_length_for_3) and (min_length_for_3 > 0))
      result += (result[-2..-1].eql?(' ☀') ? '' : ' ') + "(Perfectly Finished #{Time.now})"
    elsif ((counter < min_length_for_4) and (min_length_for_4 > 0))
      result += (result[-2..-1].eql?(' ☀') ? '' : ' ') + "(Done #{Time.now})"
    end
    mask.each{|key, value| result = result.gsub(value, key)}
    result = result.gsub("\n\n\n\n\n","\n").gsub("\n\n\n\n","\n").gsub("\n\n\n","\n").gsub("\n\n","\n").gsub("\n ","\n")
    result = result.gsub("       "," ").gsub("      "," ").gsub("     "," ").gsub("    "," ").gsub("   "," ").gsub("  "," ")
    result = result.gsub("-------","#").gsub("------","#").gsub("-----","#").gsub("----","#").gsub("---","#").gsub("--","#")
    result = result.gsub("#######","#").gsub("######","#").gsub("#####","#").gsub("####","#").gsub("###","#").gsub("##","#")
    result
  end

  def call(severity, timestamp, progname, msg)
    riana_custom_log_message_styler(String === msg ? msg : msg.inspect) + "\n"
  end
end
