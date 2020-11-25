module Global
  
  #Estas lineas crean el directorio .my_rns y el cuaderno global si es que no existen
  FileUtils.mkdir_p("#{Dir.home}/.my_rns") unless Dir.exists?("#{Dir.home}/.my_rns")
  FileUtils.mkdir_p("#{Dir.home}/.my_rns/global$") unless Dir.exists?("#{Dir.home}/.my_rns/global$")
  
  def system_dir  
    "#{Dir.home}/.my_rns"
  end
  
  def is_valid_name? name
    ex = /^[a-zA-Z\d\s]*$/
    return ex.match(name)
  end
  
  def is_global? title
    if title === "global$"
      return true
    end
    false
  end
  
  def book_exist? book
    return Dir.exist?("#{self.system_dir}/#{book}")
  end
  
  def note_exist? book, title
    return File.exist?("#{self.system_dir}/#{book}/#{title}.rn")
  end
end
