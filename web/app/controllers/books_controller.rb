class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  include ApplicationHelper
  # GET /books or /books.json
  def index

    @books = Book.where(user_id: current_user.id).all
    @notes = Note.where(book_id:  [nil], user_id: current_user.id)
  end

  # GET /books/1 or /books/1.json
  def show
    @book_id = request.query_parameters
    @book_name =  Book.where(id: @book_id[:book]).first
    @notes = Note.where(book_id: @book_id[:book])
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    @book[:user_id] = current_user.id
    @exist = Book.where(name: @book[:name], user_id: current_user.id)
    
    if ( (is_valid_name? @book[:name]).nil? )
      return redirect_to '/books', flash:{messages: "Los cuadernos solo pueden contener letras, números y espacios" }
    end

    if @exist.any?
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
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :user_id)
    end
end