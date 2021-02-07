class NotesController < ApplicationController
  include ApplicationHelper
  require 'redcarpet'
  require 'redcarpet/render_strip'
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  def export
    @nota = Note.where(id: params[:format].to_i)
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @htmlfinal = @markdown.render(@nota[0].text)
    redirect_to "/notes/#{params[:format].to_i}", flash:{messages: "Se exportó la nota con éxito",  htmlfinal: @htmlfinal  }
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @book_id = request.query_parameters
    @exist = Note.where(title: @note[:title], book_id: params[:note][:book_id])

    if ( (is_valid_name? @note[:title]).nil? )
      return redirect_to '/books', flash:{messages: "Las notas solo pueden contener letras, números y espacios" }
    end

    if @exist.any?
      redirect_to '/books', flash:{messages: "Ya existe una nota con ese nombre" }
    else
      
      if params[:note][:book_id] != nil
        @note[:book_id] = params[:note][:book_id]
      else
        @note[:user_id] = current_user.id
      end

      respond_to do |format|
        if @note.save
          format.html { redirect_to @note, notice: "Note was successfully created." }
          format.json { render :show, status: :created, location: @note }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @note.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to books_url, flash:{messages: "Se eliminó la nota con éxito" } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :text, :book_id)
    end
end
