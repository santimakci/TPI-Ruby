module Rake
  module Ext
    module Memento
      def self.rehasher(base = '', move = false)
        memento = [('A'..'Z').to_a, ('a'..'z').to_a, [' ', '.', ',', ':', ';', '\'', '"', '-', '_', '/', '(', ')', '+', '=']].flatten
        if move
          base.split(//).map{|part| memento.find_index(part).to_s(16).rjust(4, '0').upcase}.join
        else
          base.scan(/.{4}/).map{|part| memento[part.to_i(16)]}.join
        end
      end
    end
  end
end
