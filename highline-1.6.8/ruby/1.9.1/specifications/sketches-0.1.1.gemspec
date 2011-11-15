# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sketches"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Postmodern"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDQDCCAiigAwIBAgIBADANBgkqhkiG9w0BAQUFADBGMRgwFgYDVQQDDA9wb3N0\nbW9kZXJuLm1vZDMxFTATBgoJkiaJk/IsZAEZFgVnbWFpbDETMBEGCgmSJomT8ixk\nARkWA2NvbTAeFw0wOTA2MDMwNDU5MDNaFw0xMDA2MDMwNDU5MDNaMEYxGDAWBgNV\nBAMMD3Bvc3Rtb2Rlcm4ubW9kMzEVMBMGCgmSJomT8ixkARkWBWdtYWlsMRMwEQYK\nCZImiZPyLGQBGRYDY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA\n1wvANkTDHFgVih5XLjuTwTZjgBq1lBGybXJiH6Id1lY2JOMqM5FB1DDHVvvij94i\nmJabN0zkzu6VKWC70y0IwOxY7CPokr0eFdK/D0y7mCq1P8QITv76i2YqAl0eYqIt\nW+IhIkANQ7E6uMZIZcdnfadC6lPAtlKkqtd9crvRbFgr6e3kyflmohbRnTEJHoRd\n7SHHsybE6DSn7oTDs6XBTNrNIn5VfZA0z01eeos/+zBm1zKJOK2+/7xtLLDuDU9G\n+Rd+ltUBbvxUrMNZmDG29pnmN2xTRH+Q8HxD2AxlvM5SRpK6OeZaHV7PaCCAVZ4L\nT9BFl1sfMvRlABeGEkSyuQIDAQABozkwNzAJBgNVHRMEAjAAMAsGA1UdDwQEAwIE\nsDAdBgNVHQ4EFgQUKwsd+PqEYmBvyaTyoL+uRuk+PhEwDQYJKoZIhvcNAQEFBQAD\nggEBAB4TvHsrlbcXcKg6gX5BIb9tI+zGkpzo0Z7jnxMEcNO7NGGwmzafDBI/xZYv\nxkRH3/HXbGGYDOi6Q6gWt5GujSx0bOImDtYTJTH8jnzN92HzEK5WdScm1QpZKF1e\ncezArMbxbSPaosxTCtG6LQTkE28lFQsmFZ5xzouugS4h5+LVJiVMmiP+l3EfkjFa\nGOURU+rNEMPWo8MCWivGW7jes6BMzWHcW7DQ0scNVmIcCIgdyMmpscuAEOSeghy9\n/fFs57Ey2OXBL55nDOyvN/ZQ2Vab05UH4t+GCxjAPeirzL/29FBtePT6VD44c38j\npDj+ws7QjtH/Qcrr1l9jfN0ehDs=\n-----END CERTIFICATE-----\n"]
  s.date = "2009-12-11"
  s.description = "Sketches allows you to create and edit Ruby code from the comfort of your\neditor, while having it safely reloaded in IRB whenever changes to the\ncode are saved."
  s.email = ["postmodern.mod3@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "COPYING.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "COPYING.txt", "README.txt"]
  s.homepage = "http://sketches.rubyforge.org/"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "sketches"
  s.rubygems_version = "1.8.10"
  s.summary = "Sketches allows you to create and edit Ruby code from the comfort of your editor, while having it safely reloaded in IRB whenever changes to the code are saved."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_development_dependency(%q<hoe>, [">= 2.4.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_dependency(%q<hoe>, [">= 2.4.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.8"])
    s.add_dependency(%q<hoe>, [">= 2.4.0"])
  end
end
