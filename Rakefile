
task :test do |t|
  sh "killall \"iPhone Simulator\" || true"
  sh "xctool -workspace GCMNavStackMachine.xcworkspace ONLY_ACTIVE_ARCH=NO ARCHS=i386 -scheme GCMNavStackMachine -sdk iphonesimulator clean build"
  sh "xcodebuild test -workspace GCMNavStackMachine.xcworkspace -scheme GCMNavStackMachine -destination OS=6.1,name=iPhone 2>&1 | ocunit2junit"
end
