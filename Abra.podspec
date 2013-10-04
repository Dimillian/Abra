Pod::Spec.new do |s|
  s.name         = 'Abra'
  s.version      = '0.0.1'
  s.summary      = 'Coming soon'
  s.author = {
    'Thomas Ricouard' => 'ricouard77@gmail.com'
  }
  s.source = {
    :git => 'https://github.com/Dimillian/Abra.git',
    :tag => '0.0.1'
  }
  s.source_files = 'Abra/*.{h,m}'
  s.dependency     'AFNetworking'
  s.dependency     'Mantle'
  s.requires_arc =  true
end