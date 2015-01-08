#!/usr/bin/python
#Script that connects to the MySQL database and parses data from an html table
#Import the mysql.connector library/module
#
#
import sys
import MySQLdb as mysql
import time
import glob
import re
import socket
import os
import select

if (len(sys.argv)>1):
  rundir = sys.argv[1]
else:
  message = ("usage: "+sys.argv[0]+" <rundir> <config_file:optional>")
  sys.exit(message)

configfile = "/home/hiseq.clinical/.scilifelabrc"
if (len(sys.argv)>2):
  if os.path.isfile(sys.argv[2]):
    configfile = sys.argv[2]
    
params = {}
with open(configfile, "r") as confs:
  for line in confs:
    if len(line) > 5 and not line[0] == "#":
      line = line.rstrip()
      pv = line.split(" ")
      params[pv[0]] = pv[1]

for val in params:
  print val, params[val]

now = time.strftime('%Y-%m-%d %H:%M:%S')
# this script is written for database version:
_VERSION_ = params['DBVERSION']

cnx = mysql.connect(user=params['CLINICALDBUSER'], port=int(params['CLINICALDBPORT']), host=params['CLINICALDBHOST'], 
                    passwd=params['CLINICALDBPASSWD'], db=params['STATSDB'])
cursor = cnx.cursor()

cursor.execute(""" SELECT major, minor, patch FROM version ORDER BY time DESC LIMIT 1 """)
row = cursor.fetchone()
if row is not None:
  major = row[0]
  minor = row[1]
  patch = row[2]
else:
  sys.exit("Incorrect DB, version not found.")
if (str(major)+"."+str(minor)+"."+str(patch) == _VERSION_):
  print params['STATSDB'] + " Correct database version "+str(_VERSION_)+"   DB "+params['STATSDB']
else:
  exit (params['STATSDB'] + "Incorrect DB version. This script is made for "+str(_VERSION_)+" not for "
         +str(major)+"."+str(minor)+"."+str(patch))
         
print "\n\t\tIf this is INCORRECT press <enter> else do nothing [will timeout in 5 sec]"
i, o, e = select.select( [sys.stdin], [], [], 5 )
if (i):
  sys.exit("\nWill exit . . . due to manual intervention.")
else:
  print "\n . . . continues after 5 sec delay!"

runbase = params['RUNFOLDER']
oldrunbase = params['OLDRUNFOLDER']

print rundir
print runbase
print oldrunbase

  
exit(0)
