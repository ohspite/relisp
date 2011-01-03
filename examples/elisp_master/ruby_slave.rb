$:.unshift File.join(File.dirname(__FILE__), "../../lib") 
require 'relisp'

slave = Relisp::RubySlave.new

def sample_ruby_method1
  elisp_eval("(+ 1 5)")
end

def sample_ruby_method2
  elisp_eval('(ruby-eval "(1 + 5)")')
end   

def sample_ruby_method3
  Relisp::Buffer.new("ruby-created-buffer")
end

def sample_ruby_method4
  frame=  Relisp::Frame.new({:width => 80, :height => 20, :name => "ruby frame"})
  frame.height
  frame.height=60
  frame.height
end 

slave.start