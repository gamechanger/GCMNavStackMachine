require 'erubis'

template = File.read(File.dirname(__FILE__) + "/GCMNavStackMachine.podspec.erb")
template = Erubis::Eruby.new(template)
puts template.result(:version => ARGV[0])

