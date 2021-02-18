class Book < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy


  def self.book_by_id idbook
    self.where(id: idbook).first
  end

  def self.exist_book? book_name, id_user
    @exist = Book.where(name: book_name, user_id: id_user)
    @exist.any?
  end

end
