#
# Be sure to run `pod lib lint Timber.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TimberSwift'
  s.version          = '0.1.0'
  s.summary          = 'A file-based logging framework written in Swift'
  s.description      = 'Timber is a file-based logging framework written in Swift'
  s.homepage         = 'https://github.com/MaxKramer/Timber'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Kramer' => 'max@maxkramer.co' }
  s.source           = { :git => 'https://github.com/MaxKramer/Timber.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MaxKramer'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Timber/Classes/**/*'
end
