## Ref:
##   https://docs.python.org/3/library/argparse.html
##
import sys, os
import argparse
import logging


__version__ = "0.01"

def cli():
  logger = logging.getLogger(__name__)

  # Version msg
  progname = os.path.basename(sys.argv[0])

  parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter,
            description='''Description:
  What the program does
  ''',
            epilog='''Examples:
  %(prog)s filename
  %(prog)s -c 2 filename
  %(prog)s -V | --version
  ''')

  parser.add_argument('filename')           # positional argument
  parser.add_argument('-d', '--dst'    , default='/tmp'      , help='Destination dir. Default "/tmp".')
  parser.add_argument('-c', '--count'  , default=1, type=int , help='Number of repetitions')
  parser.add_argument('-v', '--verbose', action='store_true' , default=False, help='Default: False'  )
  parser.add_argument('-V', '--version', action='version'    , version=f"Version: {progname} {__version__}")


  args = parser.parse_args()

  logger.warning( f"CLI args: [{args}]")
  logger.critical(f"CLI args: [{args}]")

  return(args)


def log():
  # Default: INFO
  log_level = os.environ.get('LOGLEVEL', 'INFO').upper()
  log_fname = os.environ.get('LOGFILE','./application.log')

  # Validate
  num_level = getattr(logging, log_level, None)
  if not isinstance(num_level, int):
    raise ValueError(f"ERROR: Invalid log level: {log_level}")

  # Set
  logging.basicConfig(
    level=num_level,
    filename=log_fname,
#   format='%(asctime)s.%(msecs)03d|%(levelname)-8s|%(module)10s:%(funcName)s:%(lineno)d | %(message)s',
#   format='%(asctime)s.%(msecs)03d|%(levelname)-8s|%(name)-15s|%(module)10s:%(funcName)s:%(lineno)d | %(message)s',
    format='%(asctime)s.%(msecs)03d|%(levelname)-8s|%(name)15s:%(funcName)s:%(lineno)d | %(message)s',
    datefmt='%F %X',
  )

  logger = logging.getLogger(__name__)
  #ogger = logging.getLogger()          # root

  logger.info('')
  logger.info('Logging: defined.')
