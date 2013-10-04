Pod::Spec.new do |s|
  s.name         = 'Abra'
  s.version      = '0.0.3'
  s.summary      = 'Coming soon'
  s.homepage     = 'https://github.com/Dimillian/Abra'
  s.author = {
    'Thomas Ricouard' => 'ricouard77@gmail.com'
  }
  s.source = {
    :git => 'https://github.com/Dimillian/Abra.git',
    :tag => '0.0.1'
  }
  s.ios.deployment_target = '7.0'
  s.public_header_files = 'Abra/*.h'
  s.source_files = 'Abra/*.{h,m}'
  s.dependency     'AFNetworking'
  s.dependency     'Mantle'
  s.requires_arc =  true
end