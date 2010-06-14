class String
  def shorten(max=20)
    letters = self.split(//)
    if (letters.size > max)
      letters[0..max].join + '...'
    else
      self
    end
  end
end

