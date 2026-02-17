#!/usr/bin/env python3
"""Generate a BASIC loader TAP block for the two-block scroll program.

The loader does:
  10 CLEAR 24575
  20 LOAD "" CODE
  30 LOAD "" CODE
  40 RANDOMIZE USR 32768

This loads tile data (at 0x5B00) and main code (at 0x8000) as separate
CODE blocks, then executes the main program.
"""

import struct

def make_tap_block(flag, data):
    """Create a TAP block: 2-byte length + flag + data + checksum."""
    block = bytes([flag]) + data
    checksum = 0
    for b in block:
        checksum ^= b
    block += bytes([checksum])
    return struct.pack('<H', len(block)) + block

def make_basic_line(line_num, tokens):
    """Create a BASIC line: 2-byte line number (big-endian), 2-byte length, data, 0x0D."""
    data = tokens + b'\x0d'
    return struct.pack('>H', line_num) + struct.pack('<H', len(data)) + data

def num_token(n):
    """Encode a number in ZX Spectrum BASIC format."""
    s = str(n).encode('ascii')
    # Number literal: ASCII digits + 0x0E + 5-byte floating point
    # For integers 0-65535, the 5-byte format is: 00 00 low high 00
    return s + b'\x0e\x00\x00' + struct.pack('<H', n) + b'\x00'

# ZX Spectrum BASIC tokens
TK_CLEAR = b'\xfd'    # CLEAR
TK_LOAD  = b'\xef'    # LOAD
TK_CODE  = b'\xaf'    # CODE
TK_RAND  = b'\xf9'    # RANDOMIZE
TK_USR   = b'\xc0'    # USR
TK_QUOTE = b'"'

# Line 10: CLEAR 24575 (protects 0x6000 upward from BASIC)
line10 = make_basic_line(10, TK_CLEAR + num_token(24575))

# Line 20: LOAD "" CODE
line20 = make_basic_line(20, TK_LOAD + TK_QUOTE + TK_QUOTE + TK_CODE)

# Line 30: LOAD "" CODE
line30 = make_basic_line(30, TK_LOAD + TK_QUOTE + TK_QUOTE + TK_CODE)

# Line 40: RANDOMIZE USR 32768
line40 = make_basic_line(40, TK_RAND + TK_USR + num_token(32768))

basic_data = line10 + line20 + line30 + line40

# Header block: type 0 = Program
# Filename: 10 chars padded with spaces
filename = b'loader    '
# param1 = autostart line (10), param2 = start of variable area (= length of program)
header_data = bytes([0x00]) + filename + struct.pack('<H', len(basic_data)) + struct.pack('<H', 10) + struct.pack('<H', len(basic_data))

# Data block
header_block = make_tap_block(0x00, header_data)
data_block = make_tap_block(0xFF, basic_data)

with open('loader.tap', 'wb') as f:
    f.write(header_block)
    f.write(data_block)

print(f"Created loader.tap ({len(basic_data)} bytes of BASIC)")
