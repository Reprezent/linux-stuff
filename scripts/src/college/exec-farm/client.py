#!/home/rriedel1/src/Python-3.5.2/python



import socket


_HOSTNAME = "127.0.0.1"
_PORT = 55555


interface = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
interface.connect((_HOSTNAME, _PORT))

temp = input()
while True:
	interface.send(temp.encode())
	data, addr = interface.recvfrom(2048)
	print(data.decode())

