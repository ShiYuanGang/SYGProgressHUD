Pod::Spec.new do |spec|
  spec.name = "SYGProgressHUD"
  spec.version = "1.0.0"
  spec.summary = "loding and message framework for Apple platforms"
  spec.homepage = "https://github.com/ShiYuanGang/SYGProgressHUD"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Shi Yuan Gang" => '772821546@qq.com' }
  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/ShiYuanGang/SYGProgressHUD.git", tag: spec.version, submodules: true }
  spec.source_files = "SYGProgressHUD/*.{h,m}"
  
  spec.resource_bundles = {'XsProgressHUD_Resources' => ['XsProgressHUD/XsProgressHUD.bundle']}

  spec.dependency "lottie-ios", '~> 2.5'
  
  spec.subspec "MBProgressHUD" do |ss|
    ss.source_files = "XsProgressHUD/MBProgressHUD/**/*"
  end
end
