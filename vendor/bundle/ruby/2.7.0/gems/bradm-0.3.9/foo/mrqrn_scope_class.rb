class Aries
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

  protected
    FOXA = 'FOXA'
    voxa = 'VOXA'
    @ioxa = 'IOXA'
    @@coxa = 'COXA'
    $goxa = 'GOXA'

    def moia
      p 'MOIA'
    end

    def self.moca
      p 'MOCA'
    end

  private
    FIXA = 'FIXA'
    vixa = 'VIXA'
    @iixa = 'IIXA'
    @@cixa = 'CIXA'
    $gixa = 'GIXA'

    def miia
      p 'MIIA'
    end

    def self.mica
      p 'MICA'
    end

  p FUXA
  p vuxa
  p @iuxa
  p @@cuxa
  p $guxa
  new.muia
  muca

  p FOXA
  p voxa
  p @ioxa
  p @@coxa
  p $goxa
  # new.moia #=> AccessError
  moca

  p FIXA
  p vixa
  p @iixa
  p @@cixa
  p $gixa
  # new.miia #=> AccessError
  mica
end

class Butis < Aries
  p FUXA
  # p vuxa #=> UndefinedError
  # p @iuxa #=> nil
  p @@cuxa
  p $guxa
  new.muia
  muca

  p FOXA
  # p voxa #=> UndefinedError
  # p @ioxa #=> nil
  p @@coxa
  p $goxa
  # new.moia #=> AccessError
  moca

  p FIXA
  # p vixa #=> UndefinedError
  # p @iixa #=> nil
  p @@cixa
  p $gixa
  # new.miia #=> AccessError
  mica
end

p Butis::FUXA
# p vuxa #=> UndefinedError
# p @iuxa #=> nil
# p @@cuxa #=> UninitializedError
p $guxa
Butis.new.muia
Butis.muca

p Butis::FOXA
# p voxa #=> UndefinedError
# p @ioxa #=> nil
# p @@coxa #=> UninitializedError
p $goxa
# Butis.new.moia #=> AccessError
Butis.moca

p Butis::FIXA
# p vixa #=> UndefinedError
# p @iixa #=> nil
# p @@cixa #=> UninitializedError
p $gixa
# Butis.new.miia #=> AccessError
Butis.mica
