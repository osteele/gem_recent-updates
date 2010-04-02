require 'rubygems/commands/query_command'
require 'rubygems/super_search'

class Gem::Commands::GrepCommand < Gem::Command
  def initialize
    super 'recent-updates', "Display the recent histories of recently updated gems"
  end

  def description # :nodoc:
    """Displays the new portions of the history files of recently updated gems."""
  end
  
  def execute
    puts "yo!"
  end
end
