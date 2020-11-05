module RN
  module Commands
    module Books

      def system_dir 
        return "/home/my_rns"
      end

      def existBook? name
        return Dir.exist?("#{self.system_dir}/#{name}")
      end

      def isGlobal? name
        if name == 'global'
          return true
        end
        return false 
      end

      class Create < Dry::CLI::Command
        include Books
        
        argument :name, required: true, desc: 'Name of the book'
        desc 'Create a book'


        def isValid? name
          total = (name).scan("/").count
          if total.positive?
            return false          
          else
            return true
          end
        end

        def bookCreate name
          Dir.mkdir "#{self.system_dir}/#{name}"  
          puts "Se creo el cuadernos satisfactoriamente"
        end

        def call(name:, **)
          if self.isValid? name 
            if !self.existBook? name
              self.bookCreate name
            else
              puts "El nombre del cuaderno ingresado ya existe"
            end
          else
            puts "Por favor recuerde no incluir el signo / en el nombre del cuaderno"
          end
        end

      end

      class Delete < Dry::CLI::Command
        include Books
        require 'fileutils'
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'
        
        def deleteInGlobal
            FileUtils.rm_rf("#{self.system_dir}/global/.")
            return "Se eliminaron todos los archivo de global"
        end

        def deleteBook name
          if self.existBook? name
            FileUtils.rm_r "#{self.system_dir}/#{name}" 
            return "Se borró el cuaderno #{name}"
          end
          return "El cuaderno no existe"
        end

        def call(name: nil, **options)
          if options[:global]
            return puts self.deleteInGlobal
          elsif self.isGlobal? name
            return puts "No puede elminar el cuaderno global"
          end
          
        end

      end

      class List < Dry::CLI::Command
        include Books
        desc 'List books'

        def call(*) 
          Dir.foreach(self.system_dir) do |dir|
            if File.directory?("#{self.system_dir}/#{dir}") && dir != "." && dir != ".."
              puts dir
            end
          end
        end
      end

      class Rename < Dry::CLI::Command
        include Books
        desc 'Rename a book'
        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        def call(old_name:, new_name:, **)
          if self.isGlobal? old_name
            return puts "No se puede modificar el nombre del cuaderno global"
          end
          if self.existBook? name
            File.rename("#{self.system_dir}/#{old_name}", "#{self.system_dir}/#{new_name}")
            return puts "Se modificó el nombre del cuaderno a: #{new_name}"
          else
            puts "El cuaderno #{old_name} no existe"
          end
        end
      end
      
    end
  end
end
