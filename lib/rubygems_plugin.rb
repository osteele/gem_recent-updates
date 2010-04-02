require 'rubygems/command_manager'

Gem::CommandManager.instance.register_command :"recent-updates"

class << Gem::Commands
  alias_method :original_const_get, :const_get

  # replace interpolated "abc-def" -> "abcDef", if name ends in "Command"
  def const_get(name)
    name = name.to_s.gsub(/-(\w)/) { |s| s[1..-1].upcase }.intern if name.to_s =~ /Command$/
    self.original_const_get(name)
  end
end
