module RN
  module Commands
    module Books

      class Create < Dry::CLI::Command
        argument :name, required: true, desc: 'Name of the book'
        desc 'Create a book'

        def book_create name
          Dir.mkdir "#{system_dir}/#{name}"  
          puts "Se creo el cuadernos satisfactoriamente"
        end

        def call(name:, **)
          if is_valid_name? name 
            if !book_exist? name
              book_create name
            else
              puts "El nombre del cuaderno ingresado ya existe"
            end
          else
            puts "Por favor recuerde que el nombre de los cuadernos solo pueden contener numeros, letras y espacios"
          end
        end

      end

      class Delete < Dry::CLI::Command
        require 'fileutils'
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'
        
        def delete_in_global
            FileUtils.rm_rf("#{system_dir}/global/.")
            return "Se eliminaron todos los archivo de global"
        end

        def delete_book name
          if book_exist? name and !is_global? name
            FileUtils.rm_r "#{system_dir}/#{name}" 
            return "Se borró el cuaderno #{name}"
          end
          return "El cuaderno no existe o es global"
        end

        def call(name: nil, **options)
          if options[:global]
            return puts delete_in_global
          else 
            if name
              return puts delete_book name
            else 
              return puts "Por favor ingrese el nombre del cuaderno que desea borrar"
            end
          end
          
        end

      end

      class List < Dry::CLI::Command
        desc 'List books'

        def call(*) 
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

        def call(old_name:, new_name:, **)
          if is_global? old_name
            return puts "No se puede modificar el nombre del cuaderno global"
          end
          if book_exist? old_name
            File.rename("#{system_dir}/#{old_name}", "#{system_dir}/#{new_name}")
            return puts "Se modificó el nombre del cuaderno a: #{new_name}"
          else
            puts "El cuaderno #{old_name} no existe"
          end
        end
      end
      
    end
  end
end
