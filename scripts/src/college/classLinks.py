#!/home/rriedel1/src/Python-3.5.2/pyhton

import sys
import http
import urllib.parse
import urllib.request
import re
import getpass 

# HEADER CONTENT
__prompt__ = "UTK class linker: See who's in your classes!"
__author__ = "Richard Alexander Riedel"
__copyright__ = ""
__credits__ = ["Richard Alexander Riedel"]
__date__ = "December 13th, 2016"

__license__ = ""
__version__ = "0.1"
__maintainter__ = "Richard Alexander Riedel"
__email__ = "richardalexriedel@yahoo.com"
__status__ = "Testing"


__warning__ = ("		-----WARNING-----			  \n"
			   "	This program takes advantage of MYUTK's\n"
			   "	lack of SQL injection protection.\n\n"
			   "	**************************************\n"
			   "	*******  USE AT YOUR OWN RISK   ******\n"
			   "	**************************************\n\n"
			   "	Any legal or disiciplinary action against you\n"
			   "	for using this software will be solely\n"
			   "	responsible to you, not the author or any affiliates.\n\n"
			   "	*********************************************\n"
			   "	***********  YOU HAVE BEEN WARNED  **********\n"
			   "	*********************************************\n")

#print(__warning__, "\n\n")

# CODE STARTS HERE

# Function Name: ExtractHiddenForms
# Inputs: HTML - Byte code HTML response from an 
#				urllib.request.urlopen().read()
#

def ExtractHiddenForms(HTML):
	HTMLDecoded = HTML.decode()
	hidden1 = re.findall("<input type=\"hidden\" name=\"lt\" value=\"(.+)\" \/>", HTMLDecoded)
	hidden2 = re.findall("<input type=\"hidden\" name=\"execution\" value=\"(.+)\" \/>", HTMLDecoded)

	return (hidden1, hidden2)


_LoginPage = "https://cas.tennessee.edu/cas/login?service=https://my.utk.edu/CASLogin.aspx&AuthProvider=AD"
_FacultyPage = "bannerssb.utk.edu/kbanpr/bwlkfcwl.P_FacClaListSum?"

_UsernameID = "username"
_PasswordID = "password"
_HiddenFieldID = "lt"
_HiddenFieldID2 = "execution"
_HiddenFieldID3 = "_eventId"

#testConnection = urllib.request.Request(_LoginPage)
with urllib.request.urlopen(_LoginPage) as response:
	hiddenData = ExtractHiddenForms((response.read()))

username = input("Username: ")
password = getpass.getpass("Password: ")

Payload = {
		   _UsernameID:     username,
		   _PasswordID:     password,
		   _HiddenFieldID:  hiddenData[0],
		   _HiddenFieldID2: hiddenData[1],
		   _HiddenFieldID3: "submit",
		   "submit":		"LOGIN"
		  }

Payload = urllib.parse.urlencode(Payload)
Payload = Payload.encode('utf-8')
ActualConnection = urllib.request.urlopen(_LoginPage, Payload)

print(ActualConnection.read().decode())

# Need cookie session management Hurray!
#	JSSession cookie etc.


