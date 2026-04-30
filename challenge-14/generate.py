import os

def _setup():
    # Configuration
    _target = "secret_flag.txt"
    _val = [36, 46, 35, 37, 57, 50, 39, 48, 47, 43, 49, 49, 43, 45, 44, 29, 37, 48, 35, 44, 54, 39, 38, 29, 33, 45, 47, 47, 35, 44, 38, 39, 48, 63]
    _key = 0x42
    
    # Process
    _buf = bytearray()
    for _v in _val:
        _buf.append(_v ^ _key)
    
    try:
        with open(_target, "wb") as _f:
            _f.write(_buf + b"\n")
        
        # Apply security constraints
        os.chmod(_target, 0)
        print("Challenge initialized successfully.")
    except Exception:
        pass

if __name__ == "__main__":
    _setup()
