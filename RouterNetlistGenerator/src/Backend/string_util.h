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

//This function joins the vector elements into a string
std::string vectorToString(std::vector<std::string> vector);

/*returns the index of the matching bracket of type "type"
 * Here, type may be [, {, or (
 * The closing bracket index will be found corresponding to
 * the first encountered opening bracket of "type" in str
 * If the match is not found in the string, 0 is returned
 * Otherwise, the index of matching parenthesis is returned.
 */
int findMatchingBracket(std::string str, char type);

/*
 * Splits a string from it's delimiter and stores the split elements into a
 * vector and returns the vector.
 * Eg. str = "a, b, c, d" and delimiter = ","
 * return: {"a", " b", " c", " d"}
 */
std::vector<std::string> split(std::string str, std::string delimiter);

/*
 * This function removes white spaces and empty string vector elements.
 * Eg: vector = {"A ", "  f  ", "", "\t B\n ", "\t"}
 * modified vector: {"A ", "  f  ", "\t B\n "}
 */
void removeEmptyStringFromVector(std::vector<std::string> &vector);

//This function trims every element of vector
void trimVectorElements(std::vector<std::string> &vector);

/*
 * Removes <erase> string from all elements of vector
 * Eg. vector: {"parameter A = 0", "parameter B = 3", "C = 5"}
 * 		erase = "parameter"
 * modified vector: {"A = 0", "B = 3", "C = 5"}
 */
void eraseFromVectorElements(std::vector<std::string> &vector, std::string erase);

#endif /* STRING_UTIL_H_ */
