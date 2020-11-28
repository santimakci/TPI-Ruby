module Aries
  FUXA = 'FUXA'
  vuxa = 'VUXA'
  @iuxa = 'IUXA'
  @@cuxa = 'CUXA'
  $guxa = 'GUXA'

  def muia
    p 'MUIA'
  end

  def self.muca
    p 'MUCA'
  end

  p FUXA
  p vuxa
  p @iuxa
  p @@cuxa
  p $guxa
  # muia #=> UndefinedError
  muca
end

module Butis
  include Aries

  p FUXA
  # p vuxa #=> UndefinedError
  # p @iuxa #=> nil
  p @@cuxa
  p $guxa
  # muia #=> UndefinedError
  # muca #=> UndefinedError
end

module Capri
  extend Aries

  # p FUXA #=> UninitializedError
  # p vuxa #=> UndefinedError
  # p @iuxa #=> nil
  # p @@cuxa #=> UninitializedError
  p $guxa
  muia
  # muca #=> UndefinedError
end

class Draco
  include Aries

  p FUXA
  # p vuxa #=> UndefinedError
  # p @iuxa #=> nil
  p @@cuxa
  p $guxa
  # muia #=> UndefinedError
  # muca #=> UndefinedError
end

class Equlus
  extend Aries

  # p FUXA #=> UninitializedError
  # p vuxa #=> UndefinedError
  # p @iuxa #=> nil
  # p @@cuxa #=> UninitializedError
  p $guxa
  muia
  # muca #=> UndefinedError
end

p Aries::FUXA
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
# Aries.muia #=> UndefinedError
Aries.muca

p Butis::FUXA
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
# Butis.muia #=> UndefinedError
# Butis.muca #=> UndefinedError

# p Capri::FUXA #=> UninitializedError
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
Capri.muia
# Capri.muca #=> UndefinedError

p Draco::FUXA
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
Draco.new.muia
# Draco.new.muca #=> UndefinedError

# p Equlus::FUXA #=> UninitializedError
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
Equlus.muia
# Equlus.muca #=> UndefinedError
