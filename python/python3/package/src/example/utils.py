import datetime as dt              # v1
from   datetime import datetime    # v2


def helper_1():
  return 1

def helper_2():
  return 2

def get_now_as_dt():
  # v1
  return dt.datetime.now().strftime("%Y-%m-%d")

def get_now_as_ts():
  # v2
  return datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
