#!/usr/bin/env python3

import sys

#v1
import example

if __name__ == '__main__':
  res = example.main.run()
  sys.exit(res)

#v2
from example.main import run

if __name__ == '__main__':
  res = run()
  sys.exit(res)

