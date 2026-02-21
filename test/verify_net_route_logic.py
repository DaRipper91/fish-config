import re
import sys

def verify_route(content, expected_iface):
    print(f"--- Testing Content ---\n{content.strip()}")
    # Regex: \n(\S+)\s+00000000
    # Note: We use \n to anchor to previous line end, ensuring we are at start of a line (except first line, but header is first)
    match = re.search(r'\n(\S+)\s+00000000', content)

    if match:
        extracted = match.group(1)
        print(f"Found match: {match.group(0)!r}")
        print(f"Extracted Interface: {extracted}")
        if extracted == expected_iface:
            print("✅ PASS")
            return True
        else:
            print(f"❌ FAIL: Expected {expected_iface}, got {extracted}")
            return False
    else:
        if expected_iface is None:
            print("✅ PASS (No match expected)")
            return True
        else:
            print(f"❌ FAIL: Expected {expected_iface}, got None")
            return False

# Test Case 1: Standard (Tabs)
content1 = """Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
eth0	00000000	0100A8C0	0003	0	0	0	00000000	0	0	0
"""
if not verify_route(content1, "eth0"): sys.exit(1)

# Test Case 2: Multiple routes, first one is default
content2 = """Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
eth0	00000000	0100A8C0	0003	0	0	0	00000000	0	0	0
wlan0	00000000	0100A8C0	0003	0	0	0	00000000	0	0	0
"""
if not verify_route(content2, "eth0"): sys.exit(1)

# Test Case 3: Spaces
content3 = "\nwlan0   00000000    ..."
if not verify_route(content3, "wlan0"): sys.exit(1)

# Test Case 4: No default route (but has 00000000 in Gateway column)
content4 = """Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
eth0	000011AC	00000000	0001	0	0	0	0000FFFF	0	0	0
"""
if not verify_route(content4, None): sys.exit(1)

# Test Case 5: Real output example
content5 = """Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
eth0	00000000	0100A8C0	0003	0	0	0	00000000	0	0	0
docker0	000011AC	00000000	0001	0	0	0	0000FFFF	0	0	0
eth0	0000A8C0	00000000	0001	0	0	0	00FFFFFF	0	0	0
"""
if not verify_route(content5, "eth0"): sys.exit(1)

print("\n🎉 All regex checks passed!")
