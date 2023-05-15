CC=gcc
CXX=g++
CFLAGS=
CPPFLAGS=
LDFLAGS=

SRC_DIR	:=	src
BIN_DIR	:=	bin
BUILD_DIR	:=	build

SOURCES	:=	$(shell find $(SRC_DIR) -name "*.cpp")	# Finds all C++ Sources
OBJECTS	:=	$(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SOURCES))	# Gives a list of all the Object Files that will be created for sources
OBJ_DIR	:=	$(sort $(dir $(OBJECTS)))	# A list of directories where object files will be created. Sort removes duplicates

TARGET=$(BIN_DIR)/NoCVerifier

all: makefolder $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(CPPFLAGS) $^ -o $@
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	echo $@
	$(CXX) $(CPPFLAGS) -c $< -o $@

makefolder:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	
echoall:
	echo $(SOURCES)
	echo $(OBJECTS)
	echo $(OBJ_DIR)
	
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BIN_DIR)
	
.PHONY: makefolder all clean
