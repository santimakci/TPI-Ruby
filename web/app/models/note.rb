class Note < ApplicationRecord
  belongs_to :book, optional: true

  def self.notes_for_book id_book
    self.where(book_id: id_book)
  end

  def self.notes_for_user id_user
    self.where(book_id: nil, user_id: id_user)
  end

  def self.note_by_id id_note
    self.where(id: id_note).first
  end

  def self.note_exist? title, id_book
    @exist = Note.where(title: title, book_id: id_book)
    @exist.any? 
  end
end
