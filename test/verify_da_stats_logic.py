import re
import unittest

class TestDaStatsLogic(unittest.TestCase):
    def setUp(self):
        # Mock outputs based on standard Linux tools
        self.uptime_output = " 14:32:01 up 1 day,  3:24,  1 user,  load average: 0.52, 0.58, 0.59"
        self.uptime_output_short = " 05:11:49 up 1 min,  2 users,  load average: 0.39, 0.21, 0.08"
        self.free_output = """
               total        used        free      shared  buff/cache   available
Mem:            7959         334        7439           0         407        7624
Swap:              0           0           0
"""
        self.df_output = """Filesystem      Size  Used Avail Use% Mounted on
overlayfs       98G   26M   93G   1% /"""
        self.df_output_space = """Filesystem      Size  Used Avail Use% Mounted on
/dev/disk1s1    466G  230G  230G  50% /"""

    def test_uptime_regex(self):
        """Verify load average extraction from uptime output."""
        pattern = r"load average: ([0-9.]+)"

        match1 = re.search(pattern, self.uptime_output)
        self.assertTrue(match1, "Should match standard uptime output")
        self.assertEqual(match1.group(1), "0.52", "Should extract correct load average")

        match2 = re.search(pattern, self.uptime_output_short)
        self.assertTrue(match2, "Should match short uptime output")
        self.assertEqual(match2.group(1), "0.39", "Should extract correct load average")

    def test_free_regex(self):
        """Verify memory usage extraction from free -m output."""
        # Regex: Mem:\s+(\d+)\s+(\d+)
        # This captures total (group 1) and used (group 2)
        pattern = r"Mem:\s+(\d+)\s+(\d+)"

        match = re.search(pattern, self.free_output)
        self.assertTrue(match, "Should match free output")
        self.assertEqual(match.group(1), "7959", "Should extract total memory")
        self.assertEqual(match.group(2), "334", "Should extract used memory")

    def test_df_parsing(self):
        """Verify disk usage extraction from df -hP output."""
        # Logic: last line, split by space, 5th element (index 4) contains percentage

        lines = self.df_output.strip().split('\n')
        last_line = lines[-1]
        parts = [p for p in last_line.split(' ') if p]
        self.assertEqual(parts[4], "1%", "Should extract correct percentage from standard df output")

        lines_space = self.df_output_space.strip().split('\n')
        last_line_space = lines_space[-1]
        parts_space = [p for p in last_line_space.split(' ') if p]
        self.assertEqual(parts_space[4], "50%", "Should extract correct percentage from df output with spaces")

if __name__ == '__main__':
    unittest.main()
