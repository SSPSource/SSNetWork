

Pod::Spec.new do |spec|

  

  spec.name         = "SSNetWork"
  spec.version      = "0.0.2"
  spec.summary      = "SSNetWork  is a based level request util based on AFNetworking."
  spec.description  = <<-DESC
  基于AFNetworking封装的网络库
                   DESC

  spec.homepage     = "https://github.com/SSPSource/SSNetWork"

  spec.license      = "MIT"
  
  spec.author             = { "Sunsp" => "2316585240@qq.com" }
  

  spec.source       = { :git => "https://github.com/SSPSource/SSNetWork.git", :tag => "#{spec.version}" }
  spec.public_header_files = 'SSNetWork/SSNetWork.h'
  spec.source_files  = "SSNetWork", "SSNetWork/*.{h,m}"
  spec.requires_arc = true
  spec.ios.deployment_target = "8.0"
  spec.dependency "AFNetworking" , "~> 3.0"

  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
