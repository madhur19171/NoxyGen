// reading a text file
// Modify the num_of_nodes befere running to appropriate values;
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include<math.h>
using namespace std;
struct dep_packets {
    int message_dep; // It is Considered as Default Arguments and no Error is Raised
    int destination;
    int departure;
    int injection;
    int vc;
    int priority;
};

struct arr_packets {
    int message_arr; // It is Considered as Default Arguments and no Error is Raised
    int source;
    int arrival;
    int vc;
};

int main(int argc, char *argv[])
{
    int num_of_nodes = 225;
    string line;
    ifstream myfile(argv[1]);
   int message_completed=0;
   int per_vc_th[4];
   int per_vc_lat[4];
   int per_vc_injection[4];
   for(int i=-0;i<4;i++)
   {
       per_vc_th[i]=0;
       per_vc_lat[i]=0;
       per_vc_injection[i]=0;
   }
   int initial_time=0;
   int final_time=0;
   int total_latency=0;
   int mesg_wait=0;
   int load=-1;
   int prev=0;
   //unit is flits
   int standard_message_length=8;
    vector<vector<dep_packets*>> d_terminal;
    vector<vector< arr_packets*>> a_terminal;
    
    for (int id = 0; id < num_of_nodes; id++)
    {
        vector<int> vald;
        vector<int> vala;
      
        vector<dep_packets*> samd;
        d_terminal.push_back(samd);
        vector<arr_packets*> sama;
        a_terminal.push_back(sama);
    }

    if (myfile.is_open())
    {   int check=0;
        while (getline(myfile, line))
        {
            check++;
            if (line.find("Departure") != string::npos)
            {
                //means it is sender
               string source=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);    
                int source_i=stoi(source);
           
                string message_ds = line.substr(line.find("ge: ") + 4, line.find("Des") - line.find("ge: ") - 5); //<<"\n";
                int message_d = stoi(message_ds);
        
                string destination_ds = line.substr(line.find("n: ") + 3, line.find("Dep") - line.find("n: ") - 3);
                int destination_d=stoi(destination_ds);
     
                string destination_inj_src = line.substr(line.find("Injection_Time: ") + 16, line.find("VC:") - line.find("Injection_Time: ") - 17);
                int destination_inj=stoi(destination_inj_src);

                string departure_ds = line.substr(line.find("Time: ")+6, line.find("Inj") - line.find("Time: ")-7);
                int departure_d=stoi(departure_ds);
               
                string source_vc_s=line.substr(line.find("VC:")+4,line.find("Pri")-line.find("VC:")-4);
                int source_vc=stoi(source_vc_s);
                
                string priority_s=line.substr(line.find("ty")+4,line.length()-line.find("ty"));
                int priority=stoi(priority_s);
                
                
                dep_packets* outgoing=new  dep_packets;
                outgoing->message_dep=message_d;
                outgoing->destination=destination_d;
                outgoing->departure=departure_d ;
                outgoing->injection=destination_inj;
                outgoing->vc=source_vc;
                outgoing->priority=priority;
                if(check==1)
                {
                    initial_time=departure_d;
                    prev=departure_d;
                }
                if(departure_d==prev)
                {
                    load++;
                }
                prev=departure_d;
                
                d_terminal[source_i].push_back(outgoing);/////core fault here
              




                
            }
            else if (line.find("Arrival") != string::npos)
            {
                //means it is receiver
               
                string destination=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);
      
                int destination_i=stoi(destination);
               
                string message_as = line.substr(line.find("ge: ") + 4, line.find("Sour") - line.find("ge: ") - 5); //<<"\n";
                int message_a = stoi(message_as);
               
                string source_as = line.substr(line.find("ce: ") + 4, line.find("Arr") - line.find("ce: ") - 5);
                int source_a=stoi(source_as);
            
                string arrival_as = line.substr(line.find("me: ")+4, line.length() - line.find("me: "));
              
                int arrival_a=stoi(arrival_as);
            
                string arrival_vc_s=line.substr(line.find("VC:")+4,line.length()-line.find("VC:")-4);
          
                int arrival_vc=stoi(arrival_vc_s);
                arr_packets* incoming=new arr_packets;
                incoming->message_arr=message_a;
                incoming->source=source_a;
                incoming->arrival=arrival_a;
                incoming->vc=arrival_vc;
                final_time=arrival_a;
                a_terminal[destination_i].push_back(incoming);  ////core fault segmentation here
               
            }
        }
        myfile.close();

        //
        cout<<" Negative time => packets not routed to destination\n\n\n";
        int AMAT = 0; //Average Message Arrival Time
		int AMAT_HP = 0;
		int AMAT_LP = 0;
		int count = 0;
		int count_HP = 0;
		int count_LP = 0;
		int weightedAMAT = 0;
        for(int i=0;i<d_terminal.size();i++)
        {    
            int N = num_of_nodes;//Number of Nodes
			int DIM = floor(sqrt(N));

            int source;
            int dest;
            int dept;
            int arrv;
            int messg;
            int vc;
            int priority;
            int inj;

            

            for(int j=0;j < d_terminal[i].size();j++)
            {
             source=i;
             dest=d_terminal[i][j]->destination;
             dept=d_terminal[i][j]->departure;
             messg=d_terminal[i][j]->message_dep;
             inj=d_terminal[i][j]->injection;
             vc=d_terminal[i][j]->vc;
             priority=d_terminal[i][j]->priority;
             arrv;
             int routed=0;

             int manhattanDistance = 0;
				int srcX, srcY;
				int destX, destY;
				
				srcX = source % DIM;
				srcY = source / DIM;
				destX = dest % DIM;
				destY = dest / DIM;
				
				manhattanDistance = floor(abs(srcX - destX) + abs(srcY - destY));
            for(int k=0;k<a_terminal[dest].size();k++)
            {
                if(a_terminal[dest][k]->message_arr==messg && a_terminal[dest][k]->source==source) 
                {
                    routed=1;
                    message_completed++;
                    per_vc_th[a_terminal[dest][k]->vc]++;
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
            {
                arrv=0;
            }
            cout<<"Message "<<messg<<" from "<<source<<" to "<<dest<<" in time "<<arrv-inj<<"\n";
            total_latency+=arrv-inj;
            mesg_wait+=dept-inj;
            per_vc_lat[d_terminal[i][j]->vc]+=arrv-inj;
            per_vc_injection[d_terminal[i][j]->vc]+=dept-inj;
            }
        }
    cout<<"Debug output\n\n";
    cout<<"Overall System Load: "<<load/255<<"\n";
    cout<<"Overall Average Latency: "<<double(total_latency)/double(message_completed)<<"\n";
    cout<<"Overall Throughput: "<<double(message_completed*standard_message_length)/double(final_time-initial_time)<<" filts/cycle\n";
    cout<<"Overall message wait latency:"<<double(mesg_wait)/double(message_completed)<<"\n\n";
    cout<<"Per VC Throughput and latency and messages :"<<"\n";
    for(int i=0;i<4;i++)
    {
        cout<<"VC"<<i<<": "<<double((per_vc_th[i]*standard_message_length))/double(final_time-initial_time)<<" filts/cycle\n";
        cout<<"average latency: "<<double(per_vc_lat[i])/double(per_vc_th[i])<<"\n";
        cout<<"average message wait latency: "<<double(per_vc_injection[i]/double(per_vc_th[i]))<<"\n";
        cout<<"messages: "<<per_vc_th[i]<<"\n";
    }
    cout<<"\n\n";
    cout << "AMAT:" << (AMAT/count) << endl;
		cout << "AMAT High Priority: " << (AMAT_HP / count_HP) << endl;
		cout << "High Priority Packets: " << count_HP << endl;
		cout << "AMAT Low Priority: " << (AMAT_LP / count_LP) << endl;
		cout << "Low Priority Packets: " << count_LP << endl;
		cout << "Weighted AMAT:" << (weightedAMAT/count) << endl;
 
    }

    else
        cout << "Unable to open file";

    return 0;
}
