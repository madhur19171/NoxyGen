/*
 * string_util.h
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#ifndef STRING_UTIL_H_
#define STRING_UTIL_H_

#include <string>
#include <vector>

std::string substring(std::string str, int s, int e);//Java equivalent of substring
std::string substring(std::string str, int s);//Java equivalent of substring
std::string trim(std::string str);
std::string vectorToString(std::vector<std::string> vector);

/*returns the index of the matching bracket of type "type"
 * Here, type may be [, {, or (
 * The closing bracket index will be found corresponding to
 * the first encountered opening bracket of "type" in str
 * If the match is not found in the string, 0 is returned
 * Otherwise, the index of matching parenthesis is returned.
 */
int findMatchingBracket(std::string str, char type);

std::vector<std::string> split(std::string str, std::string delimiter);

void removeEmptyStringFromVector(std::vector<std::string> &vector);

void trimVectorElements(std::vector<std::string> &vector);

void eraseFromVectorElements(std::vector<std::string> &vector, std::string erase);

#endif /* STRING_UTIL_H_ */
