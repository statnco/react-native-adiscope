require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "RNAdiscope"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/statnco/react-native-adiscope.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}"

  s.pod_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }
  s.user_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }

  s.dependency "React-Core"
  s.dependency "Adiscope", "2.1.8.0"
  s.dependency "AdiscopeMediaAppLovin", "2.1.2.0"
  s.dependency "AdiscopeMediaAdMob", "2.0.6.0"
  s.dependency "AdiscopeMediaAdManager", "2.0.6.0"
  s.dependency "AdiscopeMediaFAN", "2.1.2.0"
  s.dependency "AdiscopeMediaMobVista", "2.1.1.0"
  s.dependency "AdiscopeMediaUnityAds", "2.1.4.0"
  s.dependency "AdiscopeMediaTapjoy", "2.1.4.0"
  s.dependency "AdiscopeMediaIronsource", "2.1.0.0"
  s.dependency "AdiscopeMediaVungle", "2.0.7.0"
  s.dependency "AdiscopeMediaChartBoost", "2.1.2.0"

  # Don't install the dependencies when we run `pod install` in the old architecture.
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
    s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig    = {
        "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
    }
    s.dependency "React-RCTFabric"
    s.dependency "React-Codegen"
    s.dependency "RCT-Folly"
    s.dependency "RCTRequired"
    s.dependency "RCTTypeSafety"
    s.dependency "ReactCommon/turbomodule/core"
  end
end
