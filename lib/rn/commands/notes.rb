module RN
  module Commands
    module Notes

      def system_dir 
        return "/home/my_rns"
      end

      def IsGlobal? title
        if title.eql? "global"
          return true
        end
        return false
      end

      def bookExist? book
        return Dir.exist?("#{self.system_dir}/#{book}")
      end
      def noteExist? book, title
        return File.exist?("#{self.system_dir}/#{book}/#{title}.rn")
      end

      def fileExistInBook? file, book
        return File.exist?("#{self.system_dir}/#{book}/#{file}.rn")
      end

      class Create < Dry::CLI::Command
        include Notes
        require 'fileutils'
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        def createFile file, book
          FileUtils.touch("#{self.system_dir}/#{book}/#{file}.rn")
          return "Se creo el archivo en #{book}"
        end

        def call(title:, **options)
          if options[:book]
            if !self.bookExist? options[:book] or self.fileExistInBook? title, options[:book]
              return puts "Verifique que exista el cuaderno y que la nota no haya sido creada"
            else
              puts self.createFile title, options[:book]
            end
          elsif !self.fileExistInBook? title, "global"
            puts self.createFile title, "global"
          else
            puts "La nota ya existe"
          end        
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'
        include Notes
        require 'fileutils'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def deleteNote book, title
          if self.bookExist? book and self.noteExist? book, title
            FileUtils.rm_r "#{self.system_dir}/#{book}/#{title}.rn" 
            return "Se borró la nota #{title}"
          end
          return "No se encontó la nota o el cuaderno existe"
        end

        def call(title:, **options)
          book = options[:book]
          if book 
            if self.bookExist? book and self.noteExist? book, title
              return puts self.deleteNote book, title
            end
          else
            if self.noteExist? "global", title
              return puts self.deleteNote "global", title
            end
          end
          return puts "Verifique que la nota y el cuaderno existan"
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          warn "TODO: Implementar modificación de la nota con título '#{title}' (del libro '#{book}').\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'
        include Notes

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def rename_note old_title, new_title, book
          File.rename("#{self.system_dir}/#{book}/#{old_title}.rn", "#{self.system_dir}/#{book}/#{new_title}.rn")
          return "Se modificó el nombre la nota a: #{new_title}" 
        end


        def call(old_title:, new_title:, **options)
          book = options[:book]
          if book 
            if self.bookExist? book and self.noteExist? book, old_title
              return puts self.rename_note old_title, new_title, book
            end
          else
            if self.noteExist? "global", old_title
              return puts self.rename_note old_title, new_title, "global"
            end          
          end
          return puts "Verifique que la nota y el cuaderno existan"
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'
        include Notes

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def listAll
          Dir.foreach(self.system_dir) do |book|
            if book != "." && book != ".."
              self.list_book book
            end
          end
        end

        def list_book book
          Dir.foreach("#{self.system_dir}/#{book}") do |file|
            if file != "." && file != ".."
               puts "Book #{book}: #{file}"
            end
          end
        end

        def call(**options)
          book = options[:book]
          global = options[:global]
          if !book and !global
            self.listAll
          else 
            if global
              self.list_book "global"
            else
              self.list_book book
            end
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          warn "TODO: Implementar vista de la nota con título '#{title}' (del libro '#{book}').\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
