require "rspec/core/formatters/base_text_formatter"
require File.dirname(__FILE__) + '/line_counter.rb'
require 'pusher'
require 'yaml'

class GolfFormatter < RSpec::Core::Formatters::BaseTextFormatter

  def initialize(output)
    super
    @passed_examples = []
    @passed_holes = []
    @failed_holes = []

    begin
      @pusher_config = YAML.load_file(File.dirname(__FILE__) + "/../pusher.yml")
    rescue Exception => e
      puts e
    end
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
    passed_nos = @passed_holes.map{|h| h.metadata[:hole]}
    failed_nos = @failed_holes.map{|h| h.metadata[:hole]}
    character_count = LineCounter.count(File.dirname(__FILE__) + "/../lib/golf.rb")

    print_scorecard(passed_nos, failed_nos, character_count)
    push(passed_nos, failed_nos, character_count)

  end

  private

    def print_scorecard(passed_nos, failed_nos, character_count)
      puts "Hole in one: #{passed_nos.join(', ')}" unless passed_nos.empty?
      puts "In the rough: #{failed_nos.join(', ')}"
      puts "Character Count: #{character_count}"
    end

    def push(passed_nos, failed_nos, character_count)
      Pusher.app_id = @pusher_config["pusher_app_id"]
      Pusher.key = @pusher_config["pusher_key"]
      Pusher.secret = @pusher_config["pusher_secret"]

      begin
        Pusher['golf'].trigger!('spec_run', {:my_name => @pusher_config["my_name"], :passed => passed_nos, :failed => failed_nos, :character_count => character_count})
      rescue Pusher::Error => e
        puts "Failed to send stats to server"
      end
    end

end
