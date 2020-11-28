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

  module Butis
    p FUXA
    # p vuxa #=> UndefinedError
    # p @iuxa #=> nil
    # p @@cuxa #=> UninitializedError
    p $guxa
    # muia #=> UndefinedError
    # muca #=> UndefinedError
  end

  class Capri
    p FUXA
    # p vuxa #=> UndefinedError
    # p @iuxa #=> nil
    # p @@cuxa #=> UninitializedError
    p $guxa
    # muia #=> UndefinedError
    # muca #=> UndefinedError
  end
end

class Draco
  FUXD = 'FUXD'
  vuxd = 'VUXD'
  @iuxd = 'IUXD'
  @@cuxd = 'CUXD'
  $guxd = 'GUXD'

  def muid
    p 'MUID'
  end

  def self.mucd
    p 'MUCD'
  end

  protected
    FOXD = 'FOXD'
    voxd = 'VOXD'
    @ioxd = 'IOXD'
    @@coxd = 'COXD'
    $goxd = 'GOXD'

    def moid
      p 'MOID'
    end

    def self.mocd
      p 'MOCD'
    end

  private
    FIXD = 'FIXD'
    vixd = 'VIXD'
    @iixd = 'IIXD'
    @@cixd = 'CIXD'
    $gixd = 'GIXD'

    def miid
      p 'MIID'
    end

    def self.micd
      p 'MICD'
    end

  module Equlus
    p FUXD
    # p vuxd #=> UndefinedError
    # p @iuxd #=> nil
    # p @@cuxd #=> UninitializedError
    p $guxd
    # new.muid #=> UndefinedError
    # mucd #=> UndefinedError

    p FOXD
    # p voxd #=> UndefinedError
    # p @ioxd #=> nil
    # p @@coxd #=> UninitializedError
    p $goxd
    # new.moid #=> UndefinedError
    # mocd #=> UndefinedError

    p FIXD
    # p vixd #=> UndefinedError
    # p @iixd #=> nil
    # p @@cixd #=> UninitializedError
    p $gixd
    # new.miid #=> UndefinedError
    # micd #=> UndefinedError
  end

  class Fornax
    p FUXD
    # p vuxd #=> UndefinedError
    # p @iuxd #=> nil
    # p @@cuxd #=> UninitializedError
    p $guxd
    # new.muid #=> UndefinedError
    # mucd #=> UndefinedError

    p FOXD
    # p voxd #=> UndefinedError
    # p @ioxd #=> nil
    # p @@coxd #=> UninitializedError
    p $goxd
    # new.moid #=> UndefinedError
    # mocd #=> UndefinedError

    p FIXD
    # p vixd #=> UndefinedError
    # p @iixd #=> nil
    # p @@cixd #=> UninitializedError
    p $gixd
    # new.miid #=> UndefinedError
    # micd #=> UndefinedError
  end
end
