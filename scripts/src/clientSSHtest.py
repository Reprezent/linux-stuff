#!/home/rriedel1/src/Python-3.5.2/python



import socket

import SSHConstants



_HOSTNAME = "hydra4.eecs.utk.edu"
_PORT = 22 


interface = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
interface.connect((_HOSTNAME, _PORT))

temp = "test123abc"
interface.send(bytes(SSHConstants.SSH_MSG_GLOBAL_REQUEST))

received, addr = interface.recvfrom(2048)
print("Address recieved from: ", addr)
print("Message recieved back: ", received)

interface.send(temp.encode())

received, addr = interface.recvfrom(2048)
print("Address recieved from: ", addr)
print("Message recieved back: ", received)

