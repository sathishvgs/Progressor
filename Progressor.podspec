#
# Be sure to run `pod lib lint Progressor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Progressor'
  s.version          = '1.0'
  s.summary          = 'To Show Progess Bar'

  s.description      = "To show progress bar in user friendly way"

  s.homepage         = 'https://github.com/sathishvgs/Progressor'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sathishvgs' => 'vgsathish1995@gmail.com' }
  s.source           = { :git => 'https://github.com/sathishvgs/Progressor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Progressor/Classes/**/*'
  
  s.resource_bundles = {
     'Progressor' => ['Progressor/Assets/**/*.{xcassets}']
  }

end
