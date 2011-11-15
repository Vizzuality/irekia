# Loads the RVM Ruby API or raises an error
#  see http://blog.thefrontiergroup.com.au/2010/12/a-brief-introduction-to-the-rvm-ruby-api/
 
module RvmLoader
  VERSION = '1.0.0'
end

# find or guess rvm path
rvm_path = File.expand_path(ENV['rvm_path'] || '~/.rvm')

# load rvm ruby api
$LOAD_PATH.unshift File.join(rvm_path, 'lib')

begin
  require 'rvm'
rescue LoadError
  raise LoadError, 'Ruby Version Manager (RVM) must be installed to use this command'
end
