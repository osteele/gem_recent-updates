require 'term/ansicolor'
require 'shellwords'

class Gem::Commands::RecentUpdatesCommand < Gem::Command
  def initialize
    super 'recent-updates', "Display the recent histories of recently updated gems"

    add_option('--since TIME', Float, 'Number of days back to look') do |value, options|
      options[:days] = value
    end
  end

  def description # :nodoc:
    """Displays the new portions of the history files of recently updated gems."""
  end
  
  def execute
    days = options[:days] || 7
    since = Time.now - days * 24 * 60 * 60
    names = Gem.source_index.map do |name, spec|
      mtime = Dir["#{spec.full_gem_path}/**/*.*"].map { |file|
        File.mtime(file)
      }.min
      spec if mtime > since
    end.compact

    run_pager

    changes = names.map do |spec|
      name, version = spec.name, spec.version
      dep = Gem::Dependency.new name, Gem::Requirement.default
      specs = Gem.source_index.search dep
      prev = specs.select { |s| s.version < version }.sort.last
      next unless prev
      "#{Term::ANSIColor::red}#{name} #{version.version}#{Term::ANSIColor::black}:\n" +
        change_summary(spec, prev) + "\n"
    end.compact

    if changes.any?
      puts "Changes since #{since}:\n\n"
      puts changes.join("\n")
    else
      puts "No changes since #{since}."
    end
  end

  private
  def change_summary(spec, other)
    change_file_pattern = '{CHANGE,RELEASE}*'
    change_file = Dir[File.join(spec.full_gem_path, change_file_pattern)].first
    return "no change history" unless change_file
    prev_change_file = File.join(other.full_gem_path, File.basename(change_file))
    prev_change_file = Dir[File.join(other.full_gem_path, change_file_pattern)].first unless File.exists?(prev_change_file)
    return File.read(change_file) unless File.exists?(prev_change_file)
    lines = `diff -d #{Shellwords::shellescape prev_change_file} #{Shellwords::shellescape change_file}`.lines.grep(/^>/)
    return lines.map {|s| s.sub(/^> /, '')}.join
  end

  # from http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
  def run_pager
    return if PLATFORM =~ /win32/
    return unless STDOUT.tty?

    read, write = IO.pipe

    unless Kernel.fork # Child process
      STDOUT.reopen(write)
      STDERR.reopen(write) if STDERR.tty?
      read.close
      write.close
      return
    end

    # Parent process, become pager
    STDIN.reopen(read)
    read.close
    write.close

    ENV['LESS'] = '-FRsX' # Don't page if the input is short enough

    Kernel.select [STDIN] # Wait until we have input before we start the pager
    pager = ENV['PAGER'] || 'less'
    exec pager rescue exec "/bin/sh", "-c", pager
  end
end
