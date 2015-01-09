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
collecttime = time.ctime(os.path.getmtime(file))
hostname = socket.gethostname()

print rundir
print runbase
print oldrunbase
print collecttime


cursor.execute(""" SELECT nas, nasdir, tonas, fromnas, startdate FROM backup WHERE runname = %s """, 
              (rundir, ))
if not cursor.fetchone():
  print "Backup parameters not yet added"
  try:
    cursor.execute(""" INSERT INTO `backup` (runname, startdate, nas, nasdir, tonas, fromnas)
                       VALUES (%s, %s, %s, %s, %s, %s) """, (rundir, start, , 
                      Systemperlv, Systemperlexe, Idstring, Program, commandline, samplesheet, SampleSheet, now, ))
  except mysql.IntegrityError, e: 
    print "Error %d: %s" % (e.args[0],e.args[1])
    exit("DB error")
# handle a specific error condition
  except mysql.Error, e:
    print "Error %d: %s" % (e.args[0],e.args[1])
    exit("Syntax error")
# handle a generic error condition
  except mysql.Warning, e:
    exit("MySQL warning")
# handle warnings, if the cursor you're using raises them
  cnx.commit()
  print "Support parameters from "+basedir+"Unaligned/support.txt now added to DB with supportparams_id: "+str(cursor.lastrowid)
  supportparamsid = cursor.lastrowid
else:
  cursor.execute(""" SELECT supportparams_id FROM supportparams WHERE document_path = %s """, 
                     (basedir+"Unaligned/support.txt", ))
  supportparamsid = cursor.fetchone()[0]
  print "Support "+basedir+"Unaligned/support.txt"+" exists in DB with supportparams_id: "+str(supportparamsid)
  

#Closes the cursor
cursor.close()
#Closes the connection to the database
cnx.close()


exit(0)
