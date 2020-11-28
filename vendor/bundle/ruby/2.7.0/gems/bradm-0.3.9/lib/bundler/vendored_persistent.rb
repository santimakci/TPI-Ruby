vendor = File.expand_path('../.gex', __FILE__)
$:.unshift(vendor) unless $:.include?(vendor)
require 'net/http/persistent'
