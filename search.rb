require 'unicode'

class String
  def downcase
    Unicode::downcase(self)
  end
  def downcase!
    self.replace downcase
  end
  def upcase
    Unicode::upcase(self)
  end
  def upcase!
    self.replace upcase
  end
  def capitalize
    Unicode::capitalize(self)
  end
  def capitalize!
    self.replace capitalize
  end

  def index_sanitize
    self.split.collect do |token|
      token.downcase.gsub(/[^А-Яа-я]/, '')
    end
  end
end

if File.exist? "index.dat"
  @data = Marshal.load open("index.dat")
else
  raise "The index data file could not be located."
end


ARGV.join(' ').index_sanitize.each do |word|
  @result ||= @data[word]
  @result &= @data[word]
end

p @result