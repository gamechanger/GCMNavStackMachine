Pod::Spec.new do |s|
  s.name         = "GCMNavStackMachine"
  s.version      = "0.1.0"
  s.summary      = "A state machine tuned for common UINavigationController needs."
  s.homepage     = "https://github.com/gamechanger/GCMNavStackMachine"
  s.author       = { "Phil Sarin" => "phil.sarin@gamechanger.io" }
  s.source       = { :git => "git@github.com:gamechanger/GCMNavStackMachine.git", :tag => "0.1.0" }
  s.source_files = "GCMNavStackMachine/GCMNavStackMachine/*.{h,m}"
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
end
