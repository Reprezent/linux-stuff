#!/home/rriedel1/src/Python-3.5.2/python


#__all__ = ??!?!?
__version__ = 0.1
__author__ = "Richard Riedel"


# Imported modules
import sys
import socket

import Crypto


class SSH:

	def __init__(self, 
				 hostname_ = "", port_ = 22,
				 username_ = None, password_ = None):

		# Variable Declarations
		self._HostName = hostname_
		self._Port = port_
		self._UserName = username_
		self._Password = password_

	
		

	def CloseConnection(self):
		print("TEST")

	def OpenConnection(self):
		print("Open")

	def _MakePrime(self):
		print("Prime!")

	def _CheckEncryptions(self):
		print("CheckENCRYPTS!")

	def _GenKey(self)
		print("GenKey!")

	def _GenIV(self)
		print("GenIV!")

	def
