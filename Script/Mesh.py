import sys

DIM=5
VC = 4
TYPE_WIDTH = 2
DATA_WIDTH = 32
FIFO_DEPTH = 4
HFBDepth = 4
FlitsPerPacket = 32

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
	if key == "FlitsPerPacket":
		FlitsPerPacket = value

class Node:
	# connectivity will have the following structure:
	# {<NextNode>: (currentOutputPort, nextNodeInputPort)}
	# NextNode is the node to which this node is connected to 
	# using currentOutputPort of current node
	# and nextNodeInputPort of the Next Node

	def __init__(self, ID, name, DATA_WIDTH=DATA_WIDTH, inputs=-1, outputs=-1, FIFO_DEPTH=FIFO_DEPTH, VC=VC, FlitsPerPacket=FlitsPerPacket, TYPE_WIDTH=TYPE_WIDTH, HFBDepth=HFBDepth):
		self.ID = ID
		self.name = name
		self.DATA_WIDTH = DATA_WIDTH
		self.inputs = inputs
		self.outputs = outputs
		self.FIFO_DEPTH = FIFO_DEPTH
		self.VC = VC
		self.FlitsPerPacket = FlitsPerPacket
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

		ret_str = "\"{name}\" [type = \"Router\", bbID= 1, ID= {ID}, in = \"{inp}\", out = \"{out}\", NSA=\"VC:{VC} TYPE_WIDTH:{TYPE_WIDTH} FlitsPerPacket:{FlitsPerPacket} HFBDepth:{HFBDepth} FIFO_DEPTH:{FIFO_DEPTH}\"];".format(
					name=self.name, ID=self.ID, inp=in_str, out=out_str, FIFO_DEPTH=self.FIFO_DEPTH, VC=self.VC, TYPE_WIDTH=self.TYPE_WIDTH, FlitsPerPacket=self.FlitsPerPacket, HFBDepth=self.HFBDepth)

		return ret_str

	def generateNodeConnectionString(self):
		ret_str = []
		for next_node, connection in self.connectivity.items():

			ret_str.append( "\"{name_from}\" ->  \"{name_to}\" [color = \"magenta\", from = \"out{from_port}\", to = \"in{to_port}\", Router = true];".format(
							name_from=self.name, name_to=next_node.name, from_port=connection[0], to_port=connection[1]) )
		return ret_str

# Limitation: Minimum dimension has to be 3X3
class Mesh:

	def __init__(self, DIM=3):
		self.DIM = DIM
		self.N = DIM * DIM 
		self.NodeList = []

		for i in range(0, self.N):
			node = Node(i, "Node" + str(i)) # Only ID and Name is set for now
			self.NodeList.append(node)

		self.CornerRouter = [self.NodeList[0], self.NodeList[self.DIM - 1], self.NodeList[self.N - self.DIM], self.NodeList[self.N - 1]]

		self.TopBoundaryRouter = [self.NodeList[i] for i in range(1, self.DIM - 1, 1)]
		self.BottomBoundaryRouter = [self.NodeList[i] for i in list(map(lambda x : x.ID + (self.DIM - 1) * self.DIM , self.TopBoundaryRouter))]
		self.LeftBoundaryRouter = [self.NodeList[i] for i in list(range(self.DIM, self.DIM * (self.DIM - 1), self.DIM))]
		self.RightBoundaryRouter = [self.NodeList[i] for i in list(map(lambda x : x.ID + (self.DIM - 1) , self.LeftBoundaryRouter))]

		self.InternalRouter = [x for x in self.NodeList if x not in self.CornerRouter 
										and x not in self.TopBoundaryRouter 
										and x not in self.BottomBoundaryRouter 
										and x not in self.LeftBoundaryRouter 
										and x not in self.RightBoundaryRouter]

		self.IntDIM = self.DIM - 2
		self.IntN = self.IntDIM * self.IntDIM

		self.InternalRouter2D = [] # Stores the Internal Routers as a 2D array
		for i in range(self.IntDIM):
			row = []
			for j in range(self.IntDIM):
				row.append(self.InternalRouter[i * self.IntDIM + j])
			self.InternalRouter2D.append(row)

		self.BoundaryRouter = []
		self.BoundaryRouter.extend(self.TopBoundaryRouter)
		self.BoundaryRouter.extend(self.BottomBoundaryRouter)
		self.BoundaryRouter.extend(self.LeftBoundaryRouter)
		self.BoundaryRouter.extend(self.RightBoundaryRouter)

		self.initNumOfInputOutput() # Initialize number of Inputs and Outputs of Nodes asap

	def initNumOfInputOutput(self): # Sets the number of inputs and outputs in Corner, Boundary and Internal routers
		for node in self.CornerRouter:
			node.inputs = 3
			node.outputs = 3
		for node in self.BoundaryRouter:
			node.inputs = 4
			node.outputs = 4
		for node in self.InternalRouter:
			node.inputs = 5
			node.outputs = 5

	# Connection of Boundary Routers to the Corner Router is not made here
	def connectBoundaryRouters(self):
		# Connecting Boundary Routers
		for BoundaryRouterList in [self.TopBoundaryRouter, self.BottomBoundaryRouter, self.LeftBoundaryRouter, self.RightBoundaryRouter]:
			if len(BoundaryRouterList) >= 3:
				BoundaryRouterList[0].connect(2, BoundaryRouterList[1], 1)
				for i in range(1, len(BoundaryRouterList) - 1):
					BoundaryRouterList[i].connect(1, BoundaryRouterList[i - 1], 2) # Connecting to the Previous Node
					BoundaryRouterList[i].connect(2, BoundaryRouterList[i + 1], 1) # Connecting to the Next Node
				BoundaryRouterList[-1].connect(1, BoundaryRouterList[-2], 2)
			elif len(BoundaryRouterList) == 2:
				BoundaryRouterList[0].connect(2, BoundaryRouterList[1], 1)
				BoundaryRouterList[1].connect(1, BoundaryRouterList[0], 2)

	# Connect Corner Routers to the Boundary Routers and vice-versa
	def connectCornerRouters(self):
		# Connecting Corner Routers to the Boundary Routers to make the perimeter of Mesh
		TopLeft = self.CornerRouter[0]
		TopRight = self.CornerRouter[1]
		BottomLeft = self.CornerRouter[2]
		BottomRight = self.CornerRouter[3]

		# Top Left Corner Router
		# Bidirectional Link between Top Left corner router and the router right to it.
		TopLeft.connect(1, self.TopBoundaryRouter[0], 1)
		self.TopBoundaryRouter[0].connect(1, TopLeft, 1)
		# Bidirectional Link between Top Left corner router and the router below it.
		TopLeft.connect(2, self.LeftBoundaryRouter[0], 1)
		self.LeftBoundaryRouter[0].connect(1, TopLeft, 2)

		# Bottom Left Corner Router
		# Bidirectional Link between Bottom Left corner router and the router right to it.
		BottomLeft.connect(1, self.BottomBoundaryRouter[0], 1)
		self.BottomBoundaryRouter[0].connect(1, BottomLeft, 1)
		# Bidirectional Link between Bottom Left corner router and the router above it.
		BottomLeft.connect(2, self.LeftBoundaryRouter[-1], 2)
		self.LeftBoundaryRouter[-1].connect(2, BottomLeft, 2)

		# Top Right Corner Router
		# Bidirectional Link between Top Right corner router and the router left to it.
		TopRight.connect(1, self.TopBoundaryRouter[-1], 2)
		self.TopBoundaryRouter[-1].connect(2, TopRight, 1)
		# Bidirectional Link between Top Right corner router and the router below it.
		TopRight.connect(2, self.RightBoundaryRouter[0], 1)
		self.RightBoundaryRouter[0].connect(1, TopRight, 2)

		# Bottom Right Corner Router
		# Bidirectional Link between Bottom Right corner router and the router Left to it.
		BottomRight.connect(1, self.BottomBoundaryRouter[-1], 2)
		self.BottomBoundaryRouter[-1].connect(2, BottomRight, 1)
		# Bidirectional Link between Bottom Left corner router and the router above it.
		BottomRight.connect(2, self.RightBoundaryRouter[-1], 2)
		self.RightBoundaryRouter[-1].connect(2, BottomRight, 2)

	def connectInternalRouters(self):
		if self.IntDIM == 2:
			# Horizontal Links
			self.InternalRouter2D[0][0].connect(1, self.InternalRouter2D[0][1], 3)
			self.InternalRouter2D[0][1].connect(3, self.InternalRouter2D[0][0], 1)

			self.InternalRouter2D[1][0].connect(1, self.InternalRouter2D[1][1], 3)
			self.InternalRouter2D[1][1].connect(3, self.InternalRouter2D[1][0], 1)

			# Vertical Links
			self.InternalRouter2D[0][0].connect(2, self.InternalRouter2D[1][0], 4)
			self.InternalRouter2D[1][0].connect(4, self.InternalRouter2D[0][0], 2)

			self.InternalRouter2D[0][1].connect(2, self.InternalRouter2D[1][1], 4)
			self.InternalRouter2D[1][1].connect(4, self.InternalRouter2D[0][1], 2)
		elif self.IntDIM > 2:
			# Horizontal Links
			for i in range(0, self.IntDIM):
				self.InternalRouter2D[i][0].connect(1, self.InternalRouter2D[i][1], 3)
				for j in range(1, self.IntDIM - 1):
					self.InternalRouter2D[i][j].connect(3, self.InternalRouter2D[i][j - 1], 1)
					self.InternalRouter2D[i][j].connect(1, self.InternalRouter2D[i][j + 1], 3)
				self.InternalRouter2D[i][-1].connect(3, self.InternalRouter2D[i][-2], 1)

			# Vertical Links
			for i in range(0, self.IntDIM):
				self.InternalRouter2D[0][i].connect(2, self.InternalRouter2D[1][i], 4)
				for j in range(1, self.IntDIM - 1):
					self.InternalRouter2D[j][i].connect(4, self.InternalRouter2D[j - 1][i], 2)
					self.InternalRouter2D[j][i].connect(2, self.InternalRouter2D[j + 1][i], 4)
				self.InternalRouter2D[-1][i].connect(4, self.InternalRouter2D[-2][i], 2)




	# Connect Internal Routers to Peripheral Routers
	# Peripheral Routers are Boundary Routers + Corner Routers.
	# They form the periphery of Mesh
	def connectInternalRoutersToPeripheralRouters(self):
		for i in range(self.IntDIM):
			self.InternalRouter2D[0][i].connect(4, self.TopBoundaryRouter[i], 3)
			self.TopBoundaryRouter[i].connect(3, self.InternalRouter2D[0][i], 4)

			self.InternalRouter2D[-1][i].connect(2, self.BottomBoundaryRouter[i], 3)
			self.BottomBoundaryRouter[i].connect(3, self.InternalRouter2D[-1][i], 2)

			self.InternalRouter2D[i][0].connect(3, self.LeftBoundaryRouter[i], 3)
			self.LeftBoundaryRouter[i].connect(3, self.InternalRouter2D[i][0], 3)

			self.InternalRouter2D[i][-1].connect(1, self.RightBoundaryRouter[i], 3)
			self.RightBoundaryRouter[i].connect(3, self.InternalRouter2D[i][-1], 1)



	def connectRouters(self):
		self.connectBoundaryRouters()
		self.connectCornerRouters()
		self.connectInternalRouters()
		self.connectInternalRoutersToPeripheralRouters()
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
	
	def printNodeDefinitions(self):
		print("Corner Router: ")
		for i in self.CornerRouter:
			print(i.generateNodeDefinitionString())

		print("Top Boundary Router: ")
		for i in self.TopBoundaryRouter:
			print(i.generateNodeDefinitionString())

		print("Bottom Boundary Router:")
		for i in self.BottomBoundaryRouter:
			print(i.generateNodeDefinitionString())

		print("Left Boundary Router:")
		for i in self.LeftBoundaryRouter:
			print(i.generateNodeDefinitionString())

		print("Right Boundary Router:")
		for i in self.RightBoundaryRouter:
			print(i.generateNodeDefinitionString())

		print("Internal Router:")
		for i in self.InternalRouter:
			print(i.generateNodeDefinitionString())

		print("\n\n")

	def generateDOTFile(self):
		with open("Mesh{d0}{d1}.dot".format(d0=self.DIM, d1=self.DIM), "w") as file:
			file.write("Digraph G {\n")
			file.write("\tsplines=spline;\n\n")
			file.write("nodesep = 1\nnode [ shape = square, width = 0.7 ];\n\n")
			file.write(self.generateRankString() + "\n\n\n")
			file.write("//DHLS version: 0.1.1\" [shape = \"none\" pos = \"20,20!\"]\n")
			file.write(mesh.generateDefinitionString() + "\n\n\n")
			file.write("subgraph cluster_0 {\n\t\tlabel = \"block1\";\n")
			file.write(mesh.generateConnectionString() + "\n")
			file.write("\t}\n")
			file.write("}")



mesh = Mesh(DIM)

# mesh.printNodeDefinitions()
mesh.connectRouters()
# mesh.generateDefinitionString()
# mesh.generateConnectionString()
# mesh.generateRankString()
mesh.generateDOTFile()
