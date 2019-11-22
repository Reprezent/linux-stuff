#!/home/rriedel1/src/Python-3.5.2/python
from __future__ import print_function

import os
import sys
import subprocess

# Home directory
HOMEDIR = os.getenv("HOME")

# Input from STDIN for the name of the class directory
CLASSDIR = "/" + input("Name of Class Directory: ")

# Number of Labs to be made for the Class
NUMOFLABS = int(input("Number of Labs: "))



# This function makes the individual (Lab1 - LabX) lab Directories for the
# Grading and Labs directories
def MakeDirectories(root):
	for i in range(1, NUMOFLABS + 1):
		tmp = root + "/lab" + str(i)
	
		# If the LABSX directory exists skip it
		if(os.path.exists(tmp)):
			print("Directory " + tmp + " already exists. Skipping.", file=sys.stderr)
			continue
		
		subprocess.run(["mkdir", tmp])


#This function makes the grading and the labs directories
def MakeSubDirs(root):
	# If the GRADING directory exists skip it
	if(os.path.exists(root + "/grading")):
		print("Directory " + root + "/grading" + " already exists. Skipping.", file=sys.stderr)
	
	else:
		subprocess.run(["mkdir", root + "/grading"])
	
	# If the LABS directory exists skip it
	if(os.path.exists(root + "/labs")):
		print("Directory " + root + "/labs" + " already exists. Skipping.", file=sys.stderr)
	
	else:
		subprocess.run(["mkdir", root + "/labs"])

	MakeDirectories(root + "/grading")
	MakeDirectories(root + "/labs")



# This function makes the root directory for the class
# Example /home/rriedel1/cs360
def MakeRoot():
	# If the ROOT CLASS directory exists skip it
	if(os.path.exists(HOMEDIR + CLASSDIR)):
		print("Directory " + HOMEDIR + CLASSDIR + " already exists. Skipping.", file=sys.stderr)
	
	else:
		subprocess.run(["mkdir", HOMEDIR + CLASSDIR])
	
	MakeSubDirs(HOMEDIR + CLASSDIR)

# Runner function call
MakeRoot()
