#
#  Be sure to run `pod spec lint LTPageController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LTPageController"
  s.version      = "0.0.3"
  s.summary      = "A Custom PageViewController"


  s.description  = <<-DESC
  A Custom PageViewController
                   DESC

  s.homepage     = "https://github.com/TopSkySir/LTPageController.git"


  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "TopSkySir" => "TopSkyComeOn@163.com" }
  s.platform     = :ios, '9.0'

  s.source       = { :git => "https://github.com/TopSkySir/LTPageController.git", :tag => "#{s.version}" }
  s.swift_version = "4.2"

  s.source_files  = "LTPageController/Sources/*"

end
