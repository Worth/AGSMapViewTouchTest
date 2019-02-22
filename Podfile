project 'AGSMapViewTouchTest.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.1'

# '> 0.1' any version higher than 0.1
# '>= 0.1' version 0.1 and any higher version
# '< 0.1' any version lower than 0.1
# '<= 0.1' version 0.1 and any lower version
# '~> 0.1.2' version 0.1.2 and the versions up to 0.2, not including 0.2 and higher
# '~> 0.1' version 0.1 and the versions up to 1.0, not including 1.0 and higher
# '~> 0' version 0 and higher, basically the same as not having it

target 'AGSMapViewTouchTest' do
  use_frameworks!
  pod 'ArcGIS-Runtime-SDK-iOS', '~> 100.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2' # or '4.0'
      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = false # temporary, test without to see if Realm warnings are gone.
    end
  end
end
