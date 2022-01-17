// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>
using namespace std;


struct dep_packets {
	int message_dep; // It is Considered as Default Arguments and no Error is Raised
	int destination;
	int departure;
	int priority;
};

struct arr_packets {
	int message_arr; // It is Considered as Default Arguments and no Error is Raised
	int source;
	int arrival;
};



int main(int argc, char *argv[]){
	string line;
	ifstream myfile(argv[1]);

	vector<vector<dep_packets*>> d_terminal;
	vector<vector< arr_packets*>> a_terminal;

	int num_of_nodes = 9;
	for (int id = 0; id < num_of_nodes; id++){
		vector<int> vald;
		vector<int> vala;

		vector<dep_packets*> samd;
		d_terminal.push_back(samd);

		vector<arr_packets*> sama;
		a_terminal.push_back(sama);
	}

	if (myfile.is_open()){
		while (getline(myfile, line)){
			if (line.find("Departure") != string::npos){
				//means it is sender
				string source=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -5);

				int source_i=stoi(source);

				string message_ds = line.substr(line.find("ge: ") + 4, line.find("Des") - line.find("ge: ") - 3); //<<"\n";
				int message_d = stoi(message_ds);

				string destination_ds = line.substr(line.find("n: ") + 2, line.find("Dep") - line.find("n: ") - 3);
				int destination_d=stoi(destination_ds);

				string departure_ds = line.substr(line.find("me: ")+4, line.find("Priority") - line.find("me: ") - 3);
				
				int priority_ds = line.find("Priority: 0") != string::npos ? 0 : 1;

				int departure_d=stoi(departure_ds);


				dep_packets* outgoing=new  dep_packets;

				outgoing->message_dep=message_d;
				outgoing->destination=destination_d;
				outgoing->departure=departure_d;
				outgoing->priority = priority_ds;


				d_terminal[source_i].push_back(outgoing);
			}
			else if (line.find("Arrival") != string::npos){
				//means it is receiver
				string destination=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);
				int destination_i=stoi(destination);

				string message_as = line.substr(line.find("ge: ") + 4, line.find("Sour") - line.find("ge: ") - 5); //<<"\n";
				int message_a = stoi(message_as);

				string source_as = line.substr(line.find("ce: ") + 4, line.find("Arr") - line.find("ce: ") - 5);
				int source_a=stoi(source_as);

				string arrival_as = line.substr(line.find("me: ")+4, line.length() - line.find("me: "));
				int arrival_a=stoi(arrival_as);

				arr_packets* incoming= new arr_packets;

				incoming->message_arr=message_a;
				incoming->source=source_a;
				incoming->arrival=arrival_a;

				a_terminal[destination_i].push_back(incoming);
			}
		}
		myfile.close();

		cout<<" Negative time => packets not routed to destination\n\n\n";

		int AMAT = 0; //Average Message Arrival Time
		int AMAT_HP = 0;
		int AMAT_LP = 0;
		int count = 0;
		int count_HP = 0;
		int count_LP = 0;
		int weightedAMAT = 0;
		for(int i=0;i<d_terminal.size();i++){
			int N = 9;//Number of Nodes
			int DIM = floor(sqrt(N));
			
			int source;
			int dest;

			int dept;
			int arrv;
			int priority;

			int messg;

			for(int j=0;j < d_terminal[i].size();j++){
				source=i;
				dest=d_terminal[i][j]->destination;
				dept=d_terminal[i][j]->departure;
				messg=d_terminal[i][j]->message_dep;
				priority = d_terminal[i][j]->priority;
				int routed=0;
				
				int manhattanDistance = 0;
				int srcX, srcY;
				int destX, destY;
				
				srcX = source % DIM;
				srcY = source / DIM;
				destX = dest % DIM;
				destY = dest / DIM;
				
				manhattanDistance = floor(abs(srcX - destX) + abs(srcY - destY));

				for(int k=0;k<a_terminal[dest].size();k++){
					if(a_terminal[dest][k]->message_arr==messg && a_terminal[dest][k]->source==source){
						routed=1;
						arrv=a_terminal[dest][k]->arrival;
						
						count++;
						if(priority == 0){
							AMAT_LP += arrv;
							count_LP++;
						}
						else{
							AMAT_HP += arrv;
							count_HP++;
						}
							
						AMAT += arrv;
						weightedAMAT += arrv / manhattanDistance;
						
						break;
					}
				}
				if(routed==0)
					arrv=0;
				cout<<"Message "<<messg<<" from "<<source<<" to "<<dest<<" at time "<<arrv<<"\n";
			}
		}
		
		cout << "AMAT:" << (AMAT/count) << endl;
		cout << "AMAT High Priority: " << (AMAT_HP / count_HP) << endl;
		cout << "High Priority Packets: " << count_HP << endl;
		cout << "AMAT Low Priority: " << (AMAT_LP / count_LP) << endl;
		cout << "Low Priority Packets: " << count_LP << endl;
		cout << "Weighted AMAT:" << (weightedAMAT/count) << endl;
		
		/*cout<<"Debug output\n\n";


		cout<<"DEPARTURES\n";
		for(int i=0;i<9;i++){
			cout<<"node"<<i<<"\n";
			for(int j=0;j<d_terminal[i].size();j++){
				cout<<d_terminal[i][j]->message_dep<<" "<<d_terminal[i][j]->destination<<" "<<d_terminal[i][j]->departure;
				cout<<"\n";
			}
		}

		cout<<"ARRIVAL\n";
		for(int i=0;i<9;i++){
			cout<<"node"<<i<<"\n";
			for(int j=0;j<a_terminal[i].size();j++){
				cout<<a_terminal[i][j]->message_arr<<" "<<a_terminal[i][j]->source<<" "<<a_terminal[i][j]->arrival;
				cout<<"\n";
			}
		}*/
	}

	else
		cout << "Unable to open file";

	return 0;
}
