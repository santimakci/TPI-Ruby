module RN
  module Commands
    module Books
      
      class Create < Dry::CLI::Command
        argument :name, required: true, desc: 'Name of the book'
        desc 'Create a book'

        def call(name:, **)
          Book.create name
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'
        
        def call(name: nil, **options)
          Book.delete_book name, options[:global]
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        def call(*) 
          Book.list_books
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'
        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        def call(old_name:, new_name:, **)
          Book.rename_book old_name, new_name
        end
      end
      
    end
  end
end
