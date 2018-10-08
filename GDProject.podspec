
Pod::Spec.new do |s|
  s.name             = 'GDProject'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GDProject.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/QDFish/GDProject'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'QDFish' => 'qdfishyooooooh@gmail.com' }
  s.source           = { :git => 'https://github.com/QDFish/GDProject.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'GDProject/*'
  s.dependency 'UITableView+FDTemplateLayoutCell'
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  
end
