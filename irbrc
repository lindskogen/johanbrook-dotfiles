require 'irb/completion'
require 'irb/ext/save-history'
require 'what_methods'
require 'pp'
 
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
 
IRB.conf[:PROMPT_MODE] = :SIMPLE
 
%w[rubygems looksee/shortcuts wirble].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end
 
class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
  
  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end
 
def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end
 
def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end
 
def paste
  `pbpaste`
end
# require 'wirble'
require 'rubygems'
require 'wirble'
 
Wirble.init(:history_size => 10000)
Wirble.colorize
 
Wirble::Colorize.colors = {
  # delimiter colors
  :comma              => :white,
  :refers             => :white,
 
  # container colors (hash and array)
  :open_hash          => :white,
  :close_hash         => :white,
  :open_array         => :white,
  :close_array        => :white,
 
  # object colors
  :open_object        => :light_red,
  :object_class       => :red,
  :object_addr_prefix => :blue,
  :object_line_prefix => :blue,
  :close_object       => :light_red,
 
  # symbol colors
  :symbol             => :blue,
  :symbol_prefix      => :blue,
 
  # string colors
  :open_string        => :light_green,
  :string             => :light_green,
  :close_string       => :light_green,
 
  # misc colors
  :number             => :light_blue,
  :keyword            => :orange,
  :class              => :red,
  :range              => :light_blue,
}

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']