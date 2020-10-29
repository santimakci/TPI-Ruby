module RN
  module Commands
    module Books


      
      class Create < Dry::CLI::Command
        attr_accessor :system_dir
        def initialize 
          self.system_dir = "/home/my_rns"
        end
        desc 'Create a book'

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

        def call()
          puts "Ingrese el nombre de la nota y presione enter "
          name = (STDIN.gets).chomp
          if self.isValid? name 
            if !self.exist_book? name
              self.bookCreate name
            else
              puts "El nombre del cuaderno ingresado ya existe"
              self.call
            end
          else
            puts "Por favor recuerde no incluir el signo / en el nombre del libro"
            self.call
          end

        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          warn "TODO: Implementar borrado del cuaderno de notas con nombre '#{name}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          warn "TODO: Implementar renombrado del cuaderno de notas con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
