# libsodium.rb

require 'ffi'

module LibSodium
  extend FFI::Library
  ffi_lib ['libsodium', 'libsodium23', 'libsodium.so', 'libsodium.so.23', 'libsodium.so.23.1.0']
  
  begin
    RBNACL_AVAILABLE = if ENV['DISCORDRB_NONACL']
                       false
                     else
                       require 'rbnacl'
                       puts "libsodium available!"
					   true
                     end
  rescue LoadError
    puts "libsodium not available! You can continue to use discordrb as normal but voice support won't work.
        Read https://github.com/meew0/discordrb/wiki/Installing-libsodium for more details."
    RBNACL_AVAILABLE = false
  else
    puts "libsodium available!"
  end

end