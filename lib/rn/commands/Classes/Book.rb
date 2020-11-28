class Book
    extend Global
    require 'fileutils'
      
    ##########################################CREATE BOOK##########################################################

    def self.book_create name
        Dir.mkdir "#{system_dir}/#{name}" 
        Dir.mkdir "#{system_dir}/#{name}/exports$"   
        puts "Se creo el cuadernos satisfactoriamente"
    end

    def self.create name
        if is_valid_name? name 
          if !book_exist? name
            self.book_create name
          else
            puts "El nombre del cuaderno ingresado ya existe"
          end
        else
          puts "Por favor recuerde que el nombre de los cuadernos solo pueden contener numeros, letras y espacios"
        end
    end

    ##############################################DELETE BOOK#####################################################
    
    def self.delete_in_global
        FileUtils.rm_rf("#{system_dir}/global$/.")
        return "Se eliminaron todos los archivo que no tenían cuaderno asignado"
    end

    def self.delete_book_general name
      if book_exist? name and !is_global? name
        FileUtils.rm_r "#{system_dir}/#{name}" 
        return "Se borró el cuaderno #{name}"
      end
      return "El cuaderno no existe"
    end

    def self.delete_book name, option 
      if option
          return puts self.delete_in_global
      else 
        if name
            return puts self.delete_book_general name
        else 
            return puts "Por favor ingrese el nombre del cuaderno que desea borrar"
        end
      end
    end

    ##############################################LIST BOOK#####################################################

    def self.list_books
      Dir.foreach(system_dir) do |dir|
        if File.directory?("#{system_dir}/#{dir}") && dir != "." && dir != ".." && dir != "global$"
          puts dir
        end
      end
    end

    ##############################################RENAME BOOK#####################################################

    def self.rename_book old_name, new_name
      if is_global? old_name
        return puts "El cuaderno no existe"
      end
      if book_exist? old_name
        File.rename("#{system_dir}/#{old_name}", "#{system_dir}/#{new_name}")
        return puts "Se modificó el nombre del cuaderno a: #{new_name}"
      else
        puts "El cuaderno #{old_name} no existe"
      end
    end

end