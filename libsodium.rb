# libsodium.rb
module LibSodium
  extend FFI::Library
  ffi_lib ['libsodium', 'libsodium23', 'libsodium.so', 'libsodium.so.23', 'libsodium.so.23.1.0']
end