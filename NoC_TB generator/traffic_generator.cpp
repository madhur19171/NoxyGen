#include<iostream>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
#include<string.h>
#include<stdint.h>
#include<time.h>
using namespace std;

//Arg0: command
//Arg1: Number of nodes
//Arg2: Current Node
//Arg3: Number of Messages
int main(int argc, char** argv)
{
	srand(time(0));
	
	char file_name[512]="";
	strcat(file_name,"Node");
	strcat(file_name,argv[2]);
	strcat(file_name,".dat");
	ofstream MyFile(file_name);
	
	int currentNode = atoi(argv[2]);
	int N = atoi(argv[1]);
	int numOfMsg = atoi(argv[3]);
	
	uint32_t packet = 0;
	int destination = 0;
	
	for(int i=0;i<atoi(argv[3]);i++){
		do{
			destination = rand() % N;
		} while(destination == currentNode);
		
		for(int j = 1; j <= 6; j++){
			packet = 0;
			
			if(j == 1){
				packet = (1 << 30);
				packet = packet | (currentNode << 4) | (destination);
			} else if(j == 6){
				packet = (3 << 30);
			} else {
				packet = (2 << 30);//Flit Identifier
				packet |= (currentNode << 8);//Source
				packet |= (destination << 4);//Destination
				packet |= (j);//Flit Number
				packet = packet | (i << 12);//Message Number
			}
			
			MyFile << "0x" << hex << packet << endl;
		}
	}
	MyFile.close();
	return 0;
}
