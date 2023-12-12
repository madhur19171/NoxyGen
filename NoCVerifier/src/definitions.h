/*
 * definitions.h
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#ifndef SRC_DEFINITIONS_H_
#define SRC_DEFINITIONS_H_

enum TopologyType {
	UNDEFINED_TOPOLOGY = -1,
	MESH = 0,
	STAR = 1,
	IRREGULAR = 2,
	TORUS=3
};

enum TrafficType{
	UNDEFINED_TRAFFIC = -1,
	UNIFORM_RANDOM = 0,
	HOTSPOT = 1,
	TRANSPOSE = 2

};


#endif /* SRC_DEFINITIONS_H_ */
