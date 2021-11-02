import os
import time
print os.popen("vcgencmd measure_temp").readline()
