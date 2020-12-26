Pod::Spec.new do |spec|

  spec.name         = "DMIScanner"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of DMIScanner."

  spec.description  = "This is cool framework for scanning QR code and VIN number plates. Its can we use in others projects"

  spec.homepage     = "https://dminc.com/"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Kamlesh Kumar" => "kamkumar@dminc.com" }

  s.platform     = :ios, "9.0"

 
  spec.source       = { :git => "https://github.com/KamleshHBTI/DMIScanner.git", :tag => "#{spec.version}" }


  spec.source_files  = "DMIScanner/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"


end
