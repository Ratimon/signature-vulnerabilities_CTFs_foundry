import math
import ecdsa
import ecdsa.ellipticcurve as EC
import binascii


def inv_mod_p(x, p):
    if 1 != math.gcd(x, p):
        raise ValueError("Arguments not prime")
    q11 = 1
    q22 = 1
    q12 = 0
    q21 = 0
    while p != 0:
        temp = p
        q = x // p
        p = x % p
        x = temp
        t21 = q21
        t22 = q22
        q21 = q11 - q*q21
        q22 = q12 - q*q22
        q11 = t21
        q12 = t22
    return q11

curve = ecdsa.SECP256k1
G = curve.generator
n = G.order()

# 0x046ebd43be3f85870a1612883ffa70fc1a3daed9e953f6107a01f71dd7fe4e9e8f875264784b9df43b4faae23e7d582764111ad91f4eb79d0005f5a8bf0976cf31
# 0x046ebd43be3f85870a1612883ffa70fc1a3daed9e953f6107a01f71dd7fe4e9e
# 0x8f875264784b9df43b4faae23e7d582764111ad91f4eb79d0005f5a8bf0976cf31

# 0x4dd42356847875c8ae9fb131edaf9b823f63d6c00b850d678285e4f8eb403b7b
# 0x4fc3da7548f9ffd09259f29cbf41b5e1daa0f83dcf02fa8dd3cd42647b6606cf

hex_public_key = "046ebd43be3f85870a1612883ffa70fc1a3daed9e953f6107a01f71dd7fe4e9e8f875264784b9df43b4faae23e7d582764111ad91f4eb79d0005f5a8bf0976cf31"
public_key_bytes = binascii.unhexlify(hex_public_key)

x = int.from_bytes(public_key_bytes[1:33], byteorder="big")
y = int.from_bytes(public_key_bytes[33:], byteorder="big")

Q = EC.Point(curve.curve, x, y)
pubkey = ecdsa.VerifyingKey.from_public_point(Q, curve)

a = ecdsa.util.randrange(n-1)

valid_s = False
while not valid_s:
    b = ecdsa.util.randrange(n-1)
    b_inv = inv_mod_p(b, n)

    K = (a*G) + (b*Q)
    r = K.x() % n

    s = r * b_inv % n

    if 0 < s < n:
        valid_s = True

m = (((a * r) % n) * b_inv) % n

message_bytes32 = format(m, '064x')
r_bytes32 = format(r, '064x')
s_bytes32 = format(s, '064x')

print("message: " + message_bytes32)
print("r: " + r_bytes32)
print("s: " + s_bytes32)

sig = ecdsa.ecdsa.Signature(r, s)
if pubkey.pubkey.verifies(m, sig):
    print("SIGNATURE VERIFIED")
else:
    print("FAILED TO VERIFY")

########

# Calculate the v value for Ethereum
recovery_id = 28 if s > curve.order // 2 else 27

# Combine r, s, and v to create a signature in Solidity format
signature_solidity = r.to_bytes(32, byteorder="big") + s.to_bytes(32, byteorder="big") + bytes([recovery_id])

# Convert the signature to hexadecimal string
signature_hex = binascii.hexlify(signature_solidity).decode()

# Print the signature in Solidity format
print("Solidity signature:", signature_hex)
