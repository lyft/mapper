Pod::Spec.new do |s|
  s.name                  = "Mapper"
  s.version               = "1.0.0"
  s.summary               = "A short description of Mapper."
  s.homepage              = "https://github.com/lyft/mapper/"
  s.license               = "MIT (example)"
  s.author                = { "Keith Smiley" => "keithbsmiley@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source                = { :git => "https://github.com/lyft/mapper.git", :tag => s.version.to_s }
  s.requires_arc          = true
  s.source_files          = "Mapper/**/*.swift"
end
