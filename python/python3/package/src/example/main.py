from . import config
from . import utils

from pprint import pp

import logging


def run():

  config.log()
  logger = logging.getLogger(__name__)
  logger.info(f"Package name: {__name__}")

  args = config.cli()

  _dt = utils.get_now_as_dt()
  _ts = utils.get_now_as_ts()
  logger.info(f"Date     : {_dt}")
  logger.info(f"Timestamp: {_ts}")

  print()
  pp(args)
  print()


