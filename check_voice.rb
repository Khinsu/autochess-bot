require 'ffi'
require 'libsodium'

begin
  RBNACL_AVAILABLE = if ENV['DISCORDRB_NONACL']
                       false
                     else
                       require 'rbnacl'
                       true
                     end
rescue LoadError
  puts "libsodium not available! You can continue to use discordrb as normal but voice support won't work.
        Read https://github.com/meew0/discordrb/wiki/Installing-libsodium for more details."
  RBNACL_AVAILABLE = false
end
