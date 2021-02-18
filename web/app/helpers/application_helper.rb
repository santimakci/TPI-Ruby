module ApplicationHelper
	def is_valid_name? name
		ex = /^[a-zA-Z\d\s]*$/
    return ex.match(name)
  end

  def export id_nota
    @nota = Note.where(id: id_nota)
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @htmlfinal = @markdown.render(@nota[0].text)
    return @htmlfinal
  end
end
