#include<iostream>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
#include<string.h>
using namespace std;
int main(int argc, char** argv)
{
	char file_name[256]="";
	strcat(file_name,"delay_Node");
	strcat(file_name,argv[3]);
	strcat(file_name,".dat");
	ofstream MyFile(file_name);
	int max_value=atoi(argv[2]);
	for(int i=0;i<atoi(argv[1]);i++)
	{
		MyFile<<rand()%max_value+1<<endl;
	}
	MyFile.close();
	return 0;
}
