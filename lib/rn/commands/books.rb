module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        attr_accessor :system_dir
        argument :name, required: true, desc: 'Name of the book'
        desc 'Create a book'

        def initialize 
          self.system_dir = "/home/my_rns"
        end

        def isValid? name
          total = (name).scan("/").count
          if total.positive?
            return false          
          else
            return true
          end
        end

        def exist_book? name
          Dir.foreach(self.system_dir) do |dir|
            if dir.eql? name
              return true
            end
          end
          return false 
        end

        def bookCreate name
          Dir.mkdir "#{self.system_dir}/#{name}"  
          puts "Se creo el cuadernos satisfactoriamente"
        end

        def call(name:, **)
          if self.isValid? name 
            if !self.exist_book? name
              self.bookCreate name
            else
              puts "El nombre del cuaderno ingresado ya existe"
            end
          else
            puts "Por favor recuerde no incluir el signo / en el nombre del libro"
          end
        end

      end

      class Delete < Dry::CLI::Command
        require 'fileutils'
        desc 'Delete a book'
        attr_accessor :system_dir
        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]
        def initialize 
          self.system_dir = "/home/my_rns"
        end

        def isGlobal? name
          if name == 'global'
            return true
          end
          return false 
        end
        
        def deleteInGlobal
            FileUtils.rm_rf("#{system_dir}/global/.")
            return "Se eliminaron todos los archivo de global"
        end

        def deleteBook name
          Dir.foreach(system_dir) do |dir|
            if name == dir
              FileUtils.rm_r "#{self.system_dir}/#{name}" 
              return "Se borró el cuaderno"
            end
          end
          return "El cuaderno no existe"
        end

        def call(name: nil, **options)
          if options[:global]
            return puts self.deleteInGlobal
          elsif self.isGlobal? name
            return puts "No puede elminar el cuaderno global"
          end

          puts self.deleteBook name
          
        end

      end

      class List < Dry::CLI::Command
        desc 'List books'

        def call(*) 
          system_dir = "/home/my_rns"
          Dir.foreach(system_dir) do |dir|
            if File.directory?("#{system_dir}/#{dir}") && dir != "." && dir != ".."
              puts dir
            end
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'
        attr_accessor :system_dir
        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def initialize 
          self.system_dir = "/home/my_rns"
        end

        def call(old_name:, new_name:, **)

          if Dir.exist?("#{self.system_dir}/#{old_name}")
            File.rename("#{self.system_dir}/#{old_name}", "#{self.system_dir}/#{new_name}")
          end
        end
      end
      
    end
  end
end
