require 'base64'

base64_regexp = /^([A-Za-z0-9=]){4,}$/
base64 = "V2hhdCBjb3VsZCBiZSBzaW1wbGVyIHRoYW4gc29tZSBzaW1wbGUgYmFzZTY0ICJjaXBoZXIiPyBUaGUgY29kZQpmb3IgbmV4dCBsZXZlbCBpcyBCQUJBSkFHQUVWSUxLTklFVkVMCg=="

if base64_regexp =~ base64
  puts Base64.decode64(base64)
end
