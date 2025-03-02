"""
  This is a simple python script that just prints a random AES-256-CBC key and IV pair
  Now obviously I wouldn't trust this that well or rely on it for most projects since
  the key generation isn't totally random and I would recommend you use OpenSSL to gen
  keys instead.
"""

import os

def GenAES():
  key = os.urandom(16)  # 256 bits = 32 bytes
  iv = os.urandom(8)  # 128 bits = 16 bytes
  return key, iv

key, iv = GenAES()
print(f"AES Key (256-bit): {key.hex().upper()}")
print(f"IV (128-bit): {iv.hex().upper()}")
