class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  require 'zip'
  include ApplicationHelper
  # GET /books or /books.json
  def index
    @books = Book.where(user_id: current_user.id).all
    @notes = Note.where(book_id:  [nil], user_id: current_user.id)
  end

  # GET /books/1 or /books/1.json
  def show
    @notes = Note.notes_for_book params[:id].to_i    
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  def export_all
    filename = "notas.zip"
    temp_file = Tempfile.new(filename)
    if params[:format] != nil
      @notes_in_book = Note.notes_for_book params[:format].to_i
    else
      @notes_in_book = Note.notes_for_user current_user.id
    end
    begin
      Zip::OutputStream.open(temp_file) { |zipf| }
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        @notes_in_book.each do |nota|
          @htmlfinal = export nota.id
          file = Tempfile.new("#{nota.title}.html")
          file.write(@htmlfinal)
          file.close
          zipfile.add("#{nota.title}.html", file)
        end
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', filename: filename)
    ensure 
      temp_file.close
      temp_file.unlink
    end
  end


  # GET /books/1/edit
  def edit
    @book_user =  Book.where(id: params[:id].to_i).first
    if current_user.id != @book_user[:user_id]
      return redirect_to '/books'
    end

  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    @book[:user_id] = current_user.id

    if Book.exist_book? @book[:name], current_user.id
      redirect_to '/books/new', flash:{messages: "Ya existe un cuaderno con ese nombre" }
    else
      respond_to do |format|
        if @book.save
          format.html { redirect_to books_url,flash:{messages: "Se creo el cuaderno con éxito"} }
          format.json { render :show, status: :created, location: @book }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to '/books', flash:{messages: "Se modificó el nombre del cuaderno" }}
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, flash:{messages: "Se eliminó el cuaderno con éxito"} }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      if (Book.book_by_id params[:id]).nil?
        return redirect_to '/books'
      end
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :user_id)
    end
end
