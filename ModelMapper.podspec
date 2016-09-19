Pod::Spec.new do |s|
  s.name                      = "ModelMapper"
  s.version                   = "5.0.0-beta.2"
  s.summary                   = "A JSON deserialization library for Swift"
  s.homepage                  = "https://github.com/lyft/mapper"
  s.license                   = "Apache License, Version 2.0"
  s.author                    = { "Keith Smiley" => "keithbsmiley@gmail.com" }
  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.10"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
  s.source                    = { :git => "https://github.com/lyft/mapper.git",
                                  :tag => s.version.to_s }
  s.requires_arc              = true
  s.source_files              = "Sources/**/*.swift"
  s.module_name               = "Mapper"
end
