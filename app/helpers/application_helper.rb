module ApplicationHelper
  def clip(text, len = 120)
    return "" if text.blank?
    text.length > len ? "#{text.to_s.first(len)}…" : text
  end
end
