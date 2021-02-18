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
    @htmlfinal= self.export params[:id].to_i
  end



  def download
    @htmlfinal = export params[:format].to_i
    send_data(@htmlfinal, :filename => "#{@nota[0].title}.html", type: "application/html")
  end

  # GET /notes/new
  def new

    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
    @note_user = Note.note_by_id params[:id].to_i
    if current_user.id != @note_user.user_id
      return redirect_to '/books'
    end
  end


  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    if Note.note_exist? @note[:title], params[:note][:book_id]
      redirect_to '/books', flash:{messages: "Ya existe una nota con ese nombre" }
    else

      if params[:note][:book_id] != nil
        @note[:book_id] = params[:note][:book_id].to_i
      else
        @note[:user_id] = current_user.id
      end

      respond_to do |format|
        if @note.save
          format.html { redirect_to @note,  flash:{messages: "Se creó la nota con éxito"}}
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
        format.html { redirect_to @note,  flash:{messages: "Se actualizó la nota con éxito"}}
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
      if (Note.note_by_id params[:id]).nil?
        return redirect_to '/books'
      end
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :text, :book_id, :user_id)

    end
end
