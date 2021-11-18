/*
 * string_util.cpp
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */
#include <iostream>
#include "string_util.h"

std::string substring(std::string str, int s, int e){//Java equivalent of substring
	std::string ret = "";
	ret = str.substr(s, e - s);
	return ret;
}

std::string substring(std::string str, int s){
	return str.substr(s);
}

std::string trim(std::string str){
	std::string ret = str;

	char exclude[] = {' ', '\n', '\t'};//Characters to be removed from starting and end of str
	int numofchar = sizeof(exclude) / sizeof(exclude[0]);

	while(true){
		bool flag = false;
		for(int j = 0; j < numofchar; j++)
			if(ret.size() != 0){
				if(ret[0] == exclude[j]){
					ret = ret.substr(1);
					flag = true;
				}
			} else break;
		if(!flag)
			break;
	}

	while(true){
		bool flag = false;
		for(int j = 0; j < numofchar; j++)
			if(ret.size() != 0){
				if(ret[ret.size() - 1] == exclude[j]){
					ret = ret.substr(0, ret.size() - 1);
					flag = true;
				}
			} else break;
		if(!flag)
			break;
	}

	return ret;
}

std::string vectorToString(std::vector<std::string> vector){
	std::string ret = "";
	for(int i = 0; i < vector.size(); i++)
		ret += vector[i];
	return ret;
}

int findMatchingBracket(std::string str, char type){
	int ret = 0;
	int start = 0;

	char closingType;
	switch(type){
	case '(': closingType = ')';
	break;
	case '{': closingType = '}';
	break;
	case '[': closingType = ']';
	break;
	default: closingType = ')';
	}

	if(str.find(type) != std::string::npos){
		for(uint i = str.find(type); i < str.length(); i++){
			if(str[i] == type)
				start++;
			else if(str[i] == closingType)
				start--;
			if(start == 0){
				ret = i;
				break;
			}
		}
	}

	return ret;
}


std::vector<std::string> split(std::string str, std::string delimiter){
	std::vector<std::string> ret;

	uint pos = 0;
	std::string token;
	while (str.find(delimiter) != std::string::npos) {
		pos = str.find(delimiter);
		token = str.substr(0, pos);
		ret.push_back(token);
		str.erase(0, pos + delimiter.length());
	}
	ret.push_back(str);
	return ret;
}

void removeEmptyStringFromVector(std::vector<std::string> &vector){
	for(auto it = vector.begin(); it != vector.end(); it++){
		if(*it == "" || *it == " " || *it == "\t" || *it == "\n")
			vector.erase(it);
	}
}


void trimVectorElements(std::vector<std::string> &vector){
	for(uint i = 0; i < vector.size(); i++){
		vector[i] = trim(vector[i]);
	}
}


void eraseFromVectorElements(std::vector<std::string> &vector, std::string erase){
	for(uint i = 0; i < vector.size(); i++){
		vector[i] = vectorToString(split(vector[i], erase));
	}
}

