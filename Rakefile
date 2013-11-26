
task :test do |t|
  sh "killall \"iPhone Simulator\" || true"
  sh "xctool -workspace GCMNavStackMachine.xcworkspace ONLY_ACTIVE_ARCH=NO ARCHS=i386 -scheme GCMNavStackMachine -sdk iphonesimulator clean build"
  sh "xctool -workspace GCMNavStackMachine.xcworkspace -scheme GCMNavStackMachine -sdk iphonesimulator test -freshInstall -freshSimulator"
  sh "xctool -workspace GCMNavStackMachine.xcworkspace -scheme GCMNavStackMachine analyze -failOnWarnings"
end
