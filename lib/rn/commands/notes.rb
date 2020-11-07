module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        require 'fileutils'
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        def create_file title, book
          if book_exist? book and !note_exist? book, title
            TTY::Editor.open("#{system_dir}/#{book}/#{title}.rn")
            return "Se creo el archivo en #{book}"
          else
            return "Verifique el cuaderno exista y la nota no haya sido creada"
          end
        end

        def call(title:, **options)
          if options[:book]
              return puts create_file title, options[:book]
          else 
            return puts create_file title, "global"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'
        require 'fileutils'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def delete_note book, title
          if book_exist? book and note_exist? book, title
            FileUtils.rm_r "#{system_dir}/#{book}/#{title}.rn" 
            return "Se borró la nota #{title}"
          end
          return "No se encontó la nota o el cuaderno existe"
        end

        def call(title:, **options)
          book = options[:book]
          if book 
              return puts delete_note book, title
          else
              return puts delete_note "global", title
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

        def edit_note book, title
          if book_exist? book and note_exist? book, title
            TTY::Editor.open("#{system_dir}/#{book}/#{title}.rn")
            return "Se modificó la nota"
          else
            return "Verifique que existan la nota y el cuaderno"
          end
        end

        def call(title:, **options)
          book = options[:book]
          if book
            return puts edit_note book, title
          else
            return puts edit_note "global", title      
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def rename_note old_title, new_title, book
          if book_exist? book and note_exist? book, old_title
            File.rename("#{system_dir}/#{book}/#{old_title}.rn", "#{system_dir}/#{book}/#{new_title}.rn")
            return "Se modificó el nombre la nota a: #{new_title}" 
          else
            return "Verifique que las notas y el cuaderno existan"
          end
        end


        def call(old_title:, new_title:, **options)
          book = options[:book]
          if book         
              return puts rename_note old_title, new_title, book
          else
              return puts rename_note old_title, new_title, "global"       
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'
        
        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def list_all
          Dir.foreach("#{system_dir}") do |book|
            if book != "." && book != ".."
              list_book book
            end
          end
        end

        def list_book book
          Dir.foreach("#{system_dir}/#{book}") do |file|
            if file != "." && file != ".."
               puts "Book #{book}: #{file}"
            end
          end
        end

        def call(**options)
          book = options[:book]
          global = options[:global]
          if !book and !global
            list_all
          else 
            if global
              list_book "global"
            else
              list_book book
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

        def show_note book, title
          if book_exist? book and note_exist? book, title
            return puts File.read("#{system_dir}/#{book}/#{title}.rn")
          end
          return "Verifique el cuaderno y la nota existan"
        end

        def call(title:, **options)
          book = options[:book]
          if book
            show_note book, title
          else
            show_note "global", title
          end
        end
      end
    end
  end
end
