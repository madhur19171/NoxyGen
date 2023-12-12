import sys
from enum import Enum

DIM=5
VC = 1
TYPE_WIDTH = 2
DATA_WIDTH = 32
FIFO_DEPTH = 4
HFBDepth = 4
FlitPerPacket = 32

class Direction (Enum) :
	L = 0	# Local
	N = 1	# North
	S = 2	# South
	W = 3	# West
	E = 4	# East

for i in range(1, len(sys.argv)):
	key = sys.argv[i][0 : sys.argv[i].find('=')]
	value = sys.argv[i][sys.argv[i].find('=') + 1 : ]
	if value == '':
		continue
	value = int(value)
	if key == "DIM":
		DIM = value
	if key == "VC":
		VC = value
	if key == "TYPE_WIDTH":
		TYPE_WIDTH = value
	if key == "DATA_WIDTH":
		DATA_WIDTH = value
	if key == "FIFO_DEPTH":
		FIFO_DEPTH = value
	if key == "HFBDepth":
		HFBDepth = value
	if key == "FlitPerPacket":
		FlitPerPacket = value

class Node:
	# connectivity will have the following structure:
	# {<NextNode>: (currentOutputPort, nextNodeInputPort)}
	# NextNode is the node to which this node is connected to 
	# using currentOutputPort of current node
	# and nextNodeInputPort of the Next Node

	def __init__(self, ID, name, DATA_WIDTH=DATA_WIDTH, inputs=-1, outputs=-1, FIFO_DEPTH=FIFO_DEPTH, VC=VC, FlitPerPacket=FlitPerPacket, TYPE_WIDTH=TYPE_WIDTH, HFBDepth=HFBDepth):
		self.ID = ID
		self.name = name
		self.DATA_WIDTH = DATA_WIDTH
		self.inputs = inputs
		self.outputs = outputs
		self.FIFO_DEPTH = FIFO_DEPTH
		self.VC = VC
		self.FlitPerPacket = FlitPerPacket
		self.HFBDepth = HFBDepth
		self.TYPE_WIDTH = TYPE_WIDTH
		self.connectivity = {}

	def connect(self, currentOutputPort, nextNode, nextNodeInputPort):
		self.connectivity[nextNode] = (currentOutputPort, nextNodeInputPort)

	def generateNodeDefinitionString(self):

		# Generating Input String
		in_str = ""
		for i in range(0, self.inputs):
			in_str = in_str + "in" + str(i) + ":" + str(self.DATA_WIDTH) + " "

		# Generating Output String
		out_str = ""
		for i in range(0, self.outputs):
			out_str = out_str + "out" + str(i) + ":" + str(self.DATA_WIDTH) + " "

		ret_str = "\"{name}\" [type = \"Router\", bbID= 1, ID= {ID}, in = \"{inp}\", out = \"{out}\", NSA=\"VC:{VC} TYPE_WIDTH:{TYPE_WIDTH} FlitPerPacket:{FlitPerPacket} HFBDepth:{HFBDepth} FIFO_DEPTH:{FIFO_DEPTH}\"];".format(
					name=self.name, ID=self.ID, inp=in_str, out=out_str, FIFO_DEPTH=self.FIFO_DEPTH, VC=self.VC, TYPE_WIDTH=self.TYPE_WIDTH, FlitPerPacket=self.FlitPerPacket, HFBDepth=self.HFBDepth)

		return ret_str

	def generateNodeConnectionString(self):
		ret_str = []
		for next_node, connection in self.connectivity.items():

			ret_str.append( "\"{name_from}\" ->  \"{name_to}\" [color = \"magenta\", from = \"out{from_port}\", to = \"in{to_port}\", Router = true];".format(
							name_from=self.name, name_to=next_node.name, from_port=connection[0], to_port=connection[1]) )
		return ret_str

# Limitation: Minimum dimension has to be 3X3
class Torus:

	def __init__(self, DIM=3):
		self.DIM = DIM
		self.N = DIM * DIM 
		self.NodeList = []
		self.NodeGrid = []

		for i in range(0, self.N):
			node = Node(ID=i, name="Node" + str(i), inputs=5, outputs=5) # Only ID and Name is set for now
			self.NodeList.append(node)
			
		for x in range(0, self.DIM) :
			column = []
			for y in range(0, self.DIM) :
				column.append(self.NodeList[y * self.DIM + x])
			self.NodeGrid.append(column [ : ])


	def connectXDimRouters(self) :
		# Going Right
		for y in range(0, self.DIM) :
			for x in range(0, self.DIM) :
				self.NodeGrid[x][y].connect(Direction["E"].value, self.NodeGrid[(x + 1) if x < (self.DIM - 1) else (0)][y], Direction["W"].value)
				
		# Going Left
		for y in range(0, self.DIM) :
			for x in range(0, self.DIM) :
				self.NodeGrid[x][y].connect(Direction["W"].value, self.NodeGrid[(self.DIM - 1) if x == 0  else (x - 1)][y], Direction["E"].value)
				
	def connectYDimRouters(self) :
		# Going Down
		for x in range(0, self.DIM) :
			for y in range(0, self.DIM) :
				self.NodeGrid[x][y].connect(Direction["S"].value, self.NodeGrid[x][(y + 1) if y < (self.DIM - 1) else (0)], Direction["W"].value)
				
		# Going Up
		for x in range(0, self.DIM) :
			for y in range(0, self.DIM) :
				self.NodeGrid[x][y].connect(Direction["N"].value, self.NodeGrid[x][(self.DIM - 1) if y == 0  else (y - 1)], Direction["S"].value)
		
	def connectRouters(self):
		self.connectXDimRouters()
		self.connectYDimRouters()
		pass

	def generateDefinitionString(self):
		ret_str = ""
		print("Node Definitions:")
		for node in self.NodeList:
			nodeDefinitionString = node.generateNodeDefinitionString()
			print(nodeDefinitionString)
			ret_str = ret_str + nodeDefinitionString + "\n"
		return ret_str


	def generateConnectionString(self):
		ret_str = ""
		print("Node Connections:")
		for node in self.NodeList:
			connection_strings = node.generateNodeConnectionString()
			for connection_string in connection_strings:
				print(connection_string)
				ret_str = ret_str + connection_string + "\n"
			print("\n")
			ret_str = ret_str + "\n"
		return ret_str


	def generateRankString(self):
		ret_str = ""
		for i in range(self.DIM):
			ret_str = ret_str + "{ rank = same; "
			for j in range(self.DIM):
				ret_str = ret_str + "Node{ind}; ".format(ind=i * self.DIM + j)
			ret_str = ret_str + "}\n"
		print(ret_str)
		return ret_str

	def generateDOTFile(self):
		with open("Torus{d0}{d1}.dot".format(d0=self.DIM, d1=self.DIM), "w") as file:
			file.write("Digraph G {\n")
			file.write("\tsplines=spline;\n\n")
			file.write("nodesep = 1\nnode [ shape = square, width = 0.7 ];\n\n")
			file.write(self.generateRankString() + "\n\n\n")
			file.write("//DHLS version: 0.1.1\" [shape = \"none\" pos = \"20,20!\"]\n")
			file.write(self.generateDefinitionString() + "\n\n\n")
			file.write("subgraph cluster_0 {\n\t\tlabel = \"block1\";\n")
			file.write(self.generateConnectionString() + "\n")
			file.write("\t}\n")
			file.write("}")



torus = Torus(DIM)

# mesh.printNodeDefinitions()
torus.connectRouters()
# mesh.generateDefinitionString()
# mesh.generateConnectionString()
# mesh.generateRankString()
torus.generateDOTFile()
