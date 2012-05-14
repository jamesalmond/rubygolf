class LineCounter
  def self.count(filename)
    open(filename) do |file|
      solution = file.read
      solution.gsub!(/\s/,"")
      solution.length
    end
  end
end
