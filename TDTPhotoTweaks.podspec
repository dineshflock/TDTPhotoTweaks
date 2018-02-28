Pod::Spec.new do |s|
  s.name             = 'TDTPhotoTweaks'
  s.version          = '1.0.0'
  s.summary          = 'Tool to crop photos for iOS'
  s.description      = <<-DESC
Tool to crop, rotate, crop with aspect ratios for iOS
                       DESC

  s.homepage         = 'https://github.com/dineshflock/TDTPhotoTweaks'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dineshflock' => 'dinesh.ku@flock.com' }
  s.source           = { :git => 'https://github.com/talk-to/TDTPhotoTweaks.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'TDTPhotoTweaks/Classes/**/*'
  
  s.resource_bundles = {
    'TDTPhotoTweaks' => ['TDTPhotoTweaks/Assets/**/*.{xcassets,storyboard}']
  }

end
