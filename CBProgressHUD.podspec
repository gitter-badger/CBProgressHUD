Pod::Spec.new do |s|
  s.name         = "CBProgressHUD"
  s.version      =  "1.0.0"
  s.summary      = "模仿MBProgressHUD,实现代码轻量化和约束轻微优化."

  s.homepage     = "https://github.com/cbangchen/CBProgressHUD"
  s.license      = 'MIT'
  s.author       = { "陈超邦" => "http://cbang.info" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/cbangchen/CBProgressHUD.git", :tag => s.version }
  s.source_files  = 'CBProgressHUD/CBProgressHUD/*.{h,m}'
  s.requires_arc = true
end
