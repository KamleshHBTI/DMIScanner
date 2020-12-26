Pod::Spec.new do |spec|

  spec.name         = "DMIScanner"
  spec.version      = "0.0.1"
  spec.summary      = "This is dmi scanner framework"

  spec.description  = "This is cool framework for scanning QR code and VIN number plates. Its can we use in others projects"

  spec.homepage     = "https://dminc.com/"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Kamlesh Kumar" => "kamkumar@dminc.com" }
 
  spec.source       = { :git => "https://github.com/KamleshHBTI/DMIScanner.git", :tag => "#{spec.version}" }


  spec.source_files  = "DMIScanner/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"


end
