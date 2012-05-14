require "rspec/core/formatters/base_text_formatter"
require File.dirname(__FILE__) + '/line_counter.rb'
class GolfFormatter < RSpec::Core::Formatters::BaseTextFormatter

  def initialize(output)
    super
    @passed_examples = []
    @passed_holes = []
    @failed_holes = []
  end

  def example_passed(example)
    super
    @passed_examples << example
  end

  def example_group_finished(example_group)
    super
    if example_group.metadata[:hole]
      if example_group.examples.all?{|example| @passed_examples.include? example}
        @passed_holes << example_group
      else
        @failed_holes << example_group
      end
    end
  end

  def close
    super
    puts "Hole in one: #{@passed_holes.map{|h| h.metadata[:hole]}.join(', ')}" unless @passed_holes.empty?
    puts "In the rough: #{@failed_holes.map{|h| h.metadata[:hole]}.join(', ')}"
    puts "Character Count: #{LineCounter.count(File.dirname(__FILE__) + "/../lib/golf.rb")}"
  end
end
