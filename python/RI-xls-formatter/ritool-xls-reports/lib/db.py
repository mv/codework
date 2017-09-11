#!/usr/bin/env python3

# sqlite

import sys
import re

import sqlite3
from sqlalchemy import create_engine


# sqlite3 ftw!

db = create_engine('sqlite:///temp.db')
#df.to_sql('mydf', db)


