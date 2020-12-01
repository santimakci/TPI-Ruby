class Note
    extend Global
    require 'fileutils'

    ##########################################CREATE NOTE##########################################################

    def self.create_file title, book
        if book_exist? book and !note_exist? book, title
            TTY::Editor.open("#{system_dir}/#{book}/#{title}.rn")
            return "Se creo el archivo en #{book}"
        else
          return "Verifique el cuaderno exista y la nota no haya sido creada"
        end
    end

    def self.create title, book
        if !is_valid_name? title
            return puts "Recuerde que las notas solo pueden contener letras, números y espacios"
        else
            if book
                return puts self.create_file title, book
            else 
              return puts self.create_file title, "global$"
            end
        end
    end

    ##########################################DELETE NOTE##########################################################
    
    def self.delete_note_general book, title
        if book_exist? book and note_exist? book, title
            FileUtils.rm_r "#{system_dir}/#{book}/#{title}.rn" 
            return "Se borró la nota #{title}"
        end
        return "No se encontó la nota o el cuaderno existe"
    end

    def self.delete_note title, book
        if book 
            return puts self.delete_note_general book, title
        else
            return puts self.delete_note_general "global$", title
        end
          return puts "Verifique que la nota y el cuaderno existan"   
    end

    ##########################################EDIT NOTE##########################################################

    def self.edit_note book, title
        if book_exist? book and note_exist? book, title
            TTY::Editor.open("#{system_dir}/#{book}/#{title}.rn")
            return "Se modificó la nota"
        else
            return "Verifique que existan la nota y el cuaderno"
        end
    end

    def self.edit book, title
        if book
            return puts edit_note book, title
        else
            return puts edit_note "global$", title      
        end
    end

    ##########################################RETITLE NOTE##########################################################

    def self.rename_note old_title, new_title, book
        if book_exist? book and note_exist? book, old_title
            File.rename("#{system_dir}/#{book}/#{old_title}.rn", "#{system_dir}/#{book}/#{new_title}.rn")
            return "Se modificó el nombre la nota a: #{new_title}" 
        else
            return "Verifique que las notas y el cuaderno existan"
        end
    end

    def self.retitle old_title, new_title, book
        if book         
            return puts self.rename_note old_title, new_title, book
        else
            return puts self.rename_note old_title, new_title, "global$"       
         end
    end

    ##########################################LIST NOTE##########################################################

    def self.list_all
        Dir.foreach("#{system_dir}") do |book|
          if book != "." && book != ".."
            self.list_book book
          end
        end
    end

    def self.list_book book
        Dir.foreach("#{system_dir}/#{book}") do |file|
            if file != "." && file != ".." && File.file?("#{system_dir}/#{book}/#{file}")
                puts "Book #{book}: #{file}"
            end
        end
    end

    def self.list_notes book, global
        if !book and !global
            self.list_all
        else 
            if global
                self.list_book "global$"
            else
                self.list_book book
            end
        end 
    end

    ##########################################SHOW NOTE##########################################################

    def self.show_note book, title
        if book_exist? book and note_exist? book, title
            return File.read("#{system_dir}/#{book}/#{title}.rn")
        end
        return "Verifique el cuaderno y la nota existan"
    end

    def self.show title, book
        if book
            puts self.show_note book, title
        else
            puts self.show_note "global$", title
        end
    end

    ##########################################EXPORT NOTE##########################################################

    def self.generate_html title, book
        text = self.show_note book, title
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
        htmlfinal = markdown.render(text)
        return htmlfinal
    end

    def self.create_html title, book
        if book_exist? book and note_exist? book, title
            html_text= self.generate_html title, book
            FileUtils.touch("#{system_dir}/#{book}/exports$/#{title}.html")    
            File.write("#{system_dir}/#{book}/exports$/#{title}.html", html_text)  
            return "Se exportó el archivo #{title}"
        else
            return "Verifique el cuaderno exista y la nota no haya sido creada"
        end
    end

    def self.export_in_book book
        if book_exist? book
            self.export_all_book book
            return "Se exportaron todos los archivos del cuaderno #{book}"
        end
        "El cuaderno no existe"
    end 

    def self.export_all
        Dir.foreach("#{system_dir}") do |book|
          if book != "." && book != ".."
            self.export_all_book book
            end
        end
        return "Se exportaron todos los archivos a HTML"
    end

    def self.export_all_book book
        Dir.foreach("#{system_dir}/#{book}") do |file|
            if file != "." && file != ".." && File.file?("#{system_dir}/#{book}/#{file}")
               name = file.split(/[\.]/)
               html_text= self.generate_html name[0], book
               FileUtils.touch("#{system_dir}/#{book}/exports$/#{name[0]}.html")    
               File.write("#{system_dir}/#{book}/exports$/#{name[0]}.html", html_text)
            end
        end
    end
        
    def self.export title, book, all
        if !title and !all and !book
            return puts "Por favor especifique que desea exportar"    
        elsif all
            return puts self.export_all
        elsif book and !title
            return puts self.export_in_book book
        elsif book
            return puts self.create_html title, book
        else
            return self.create_html title, "global$"
        end
        
    end 

end