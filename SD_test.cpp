// reading a text file
// Modify the num_of_nodes and filts per message befere running to appropriate values;
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include<math.h>
using namespace std;
struct dep_packets {
    int64_t message_dep; // It is Considered as Default Arguments and no Error is Raised
    int64_t destination;
    int64_t departure;
    int64_t injection;
    int64_t vc;
    int64_t priority;
};

struct arr_packets {
    int64_t message_arr; // It is Considered as Default Arguments and no Error is Raised
    int64_t source;
    int64_t arrival;
    int64_t vc;
    int checked;
};

int main(int argc, char *argv[])
{
    int num_of_nodes = 16;
    //unit is flits
    //int standard_message_length=10;
    string line;
    ifstream myfile(argv[1]);
    /*
    vector<vector<int>> dep;
    vector<vector<int>> arr;
    */
   int64_t message_completed=0;
   int64_t per_vc_th[4];
   int64_t per_vc_lat[4];
   int64_t per_vc_injection[4];
   int64_t per_vc_starttime[4];
   int64_t per_vc_endtime[4];
  for(int i=-0;i<4;i++)
   {
       per_vc_th[i]=0;
       per_vc_lat[i]=0;
       per_vc_injection[i]=0;
       per_vc_endtime[i]=0;
       per_vc_starttime[i]=0;
   }
   int64_t initial_time=0;
   int64_t final_time=0;
   int64_t total_latency=0;
   int64_t mesg_wait=0;
   int64_t load=-1;
   int64_t prev=0;
   int64_t first_time_check=0;
    vector<vector<dep_packets*>> d_terminal;
    vector<vector< arr_packets*>> a_terminal;
    
    for (int id = 0; id < num_of_nodes; id++)
    {
        vector<int> vald;
        vector<int> vala;
        //dep.push_back(vald);
        //arr.push_back(vala);
        vector<dep_packets*> samd;
        d_terminal.push_back(samd);
        vector<arr_packets*> sama;
        a_terminal.push_back(sama);
    }

    if (myfile.is_open())
    {   int check=0;
    cout << "file opened" << endl;
        while (getline(myfile, line))
        {
            check++;
            if (line.find("Departure") != string::npos)
            {
                //means it is sender
               string source=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);
                //cout<<source<<"ssss\n";
                int64_t source_i=stol(source);
                //cout<<"source"<<source_i<<"\n";
                //cout << line.substr(line.find("e: ") + 2, line.find("Des") - line.find("e: ") - 3) << "\n";
                string message_ds = line.substr(line.find("ge: ") + 4, line.find("Des") - line.find("ge: ") - 5); //<<"\n";
                int64_t message_d = stol(message_ds);
                //cout<<message_ds<<"sssssssssssssss\n";
                string destination_ds = line.substr(line.find("n: ") + 3, line.find("Dep") - line.find("n: ") - 3);
                int64_t destination_d=stol(destination_ds);
                //cout<<destination_d<<"sdsd\n";
                string destination_inj_src = line.substr(line.find("Injection_Time: ") + 16, line.find("VC:") - line.find("Injection_Time: ") - 17);
                //cout<<destination_inj_src<<"sdsdsd\n";
                int64_t destination_inj=stol(destination_inj_src);

                string departure_ds = line.substr(line.find("Time: ")+6, line.find("Inj") - line.find("Time: ")-7);
                //cout<<departure_ds<<"sddsd\n";
                int64_t departure_d=stol(departure_ds);
                //vector<int> curr_data={message_d,destination_d,departure_d};
                //dep[source_i].push_back(message_d);
                //dep[source_i].push_back(destination_d);
                //dep[source_i].push_back(departure_d);
                string source_vc_s=line.substr(line.find("VC:")+4,line.find("Pri")-line.find("VC:")-4);
                //cout<<source_vc_s<<"\n";
                int64_t source_vc=stol(source_vc_s);
                string priority_s=line.substr(line.find("ty")+4,line.length()-line.find("ty"));
                //cout<<priority_s<<"\n";
                int64_t priority=stol(priority_s);

                for(int i=0;i<4;i++)
                {
                    if(per_vc_starttime[i]==0 && first_time_check<4 && source_vc==i)
                    {
                        per_vc_starttime[i]=departure_d;
                        first_time_check++;
                    }
                }
                
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
                //struct dep_packets outgoing;
                //outgoing.message_dep=message_d;
                //outgoing.destination=destination_d;
                //outgoing.departure=departure_d;
                d_terminal[source_i].push_back(outgoing);/////core fault here
                //d_terminal.insert(d_terminal.begin() + source_i, outgoing);




                //cout << line << "\n";
            }
            else if (line.find("Arrival") != string::npos)
            {
                //means it is receiver
                //cout<<"aaa";
                string destination=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);
                //cout<<destination<<"ssss\n";
                int64_t destination_i=stol(destination);
                //cout<<"source"<<destination_i<<"\n";//cprrect
                //cout << line.substr(line.find("ge: ") + 2, line.find("Sour") - line.find("ge: ") - 3) << "\n";
                string message_as = line.substr(line.find("ge: ") + 4, line.find("Sour") - line.find("ge: ") - 5); //<<"\n";
                int64_t message_a = stol(message_as);
                //cout<<message_a<<"mess\n";
                string source_as = line.substr(line.find("ce: ") + 4, line.find("Arr") - line.find("ce: ") - 5);
                int64_t source_a=stol(source_as);
                //cout<<source_as<<"sdsd\n";
                string arrival_as = line.substr(line.find("me: ")+4, line.length() - line.find("me: "));
                //cout<<arrival_as<<"sddsd\n";
                int64_t arrival_a=stol(arrival_as);
                //vector<int> curr_data={message_a,source_a,arrival_a};
                //arr[destination_i].push_back(message_a);
                //arr[destination_i].push_back(source_a);
                //arr[destination_i].push_back(arrival_a);
                string arrival_vc_s=line.substr(line.find("VC:")+4,line.length()-line.find("VC:")-4);
                //cout<<arrival_vc<<"sss\n";
                int64_t arrival_vc=stol(arrival_vc_s);

                for(int i=0;i<4;i++)
                {
                    if(arrival_vc==i)
                    {
                        per_vc_endtime[i]=arrival_a;
                    }
                }
                arr_packets* incoming=new arr_packets;
                incoming->message_arr=message_a;
                incoming->source=source_a;
                incoming->arrival=arrival_a;
                incoming->vc=arrival_vc;
                incoming->checked=0;
                final_time=arrival_a;
                a_terminal[destination_i].push_back(incoming);  ////core fault segmentation here
                //a_terminal.insert(a_terminal.begin()+destination_i,incoming);
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

            int64_t source;
            int64_t dest;
            int64_t dept;
            int64_t arrv;
            int64_t messg;
            int64_t vc;
            int64_t priority;
            int64_t inj;

            

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
                if(a_terminal[dest][k]->message_arr==messg && a_terminal[dest][k]->source==source && a_terminal[dest][k]->checked==0) 
                {
                    a_terminal[dest][k]->checked=1;
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
            //cout<<"arriv"<<arrv<<" "<<"inj"<<inj<<"\n";
            //cout<<"Message "<<messg<<" from "<<source<<" to "<<dest<<" in time "<<arrv-inj<<"\n";
	    if(arrv-inj>0)
	    {
              total_latency+=arrv-inj;
	      per_vc_lat[d_terminal[i][j]->vc]+=arrv-inj;
	    }
	    cout<<"total"<<total_latency<<"\n";
	    if(total_latency>372661)
		   {
			   cout<<"arriv  "<<arrv<<" "<<"inj  "<<inj<<"\n";
			   cout<<"message"<<messg<<"from"<<source<<" to " <<dest<<"in time"<<arrv<<" "<<inj<<" t "<<arrv-inj<<"\n";
			   
		   }

            mesg_wait+=dept-inj;
            per_vc_injection[d_terminal[i][j]->vc]+=dept-inj;
            }
        }
    cout<<"Debug output\n\n";
    cout<<"Overall System Load: "<<load/num_of_nodes<<"\n";
    cout<<"Overall Average Latency: "<<total_latency/message_completed<<"\n";
    cout<<"check latency"<<total_latency<<"\n";
    cout << "Messages Completed: " << message_completed << endl;
    cout<<"Overall Throughput: "<<double(message_completed)/(final_time-initial_time)<<" messages/cycle\n";
    cout<<"Overall message wait latency:"<<(mesg_wait)/message_completed<<"\n\n";
    cout<<"Per VC Throughput and latency and messages :"<<"\n";
    for(int i=0;i<4;i++)
    {
        cout<<"VC"<<i<<": "<<(double(per_vc_th[i]))/(per_vc_endtime[i]-per_vc_starttime[i])<<" messages/cycle\n";
        cout<<"average latency: "<<(per_vc_lat[i])/(per_vc_th[i])<<"\n";
	cout<<"check latency:"<<per_vc_lat[i]<<"\n";
        cout<<"average message wait latency: "<<(per_vc_injection[i]/(per_vc_th[i]))<<"\n";
        cout<<"messages: "<<per_vc_th[i]<<"\n";
    }
    cout<<"\n\n";
    cout << "AMAT:" << (AMAT/count) << endl;
		cout << "AMAT High Priority: " << (AMAT_HP / count_HP) << endl;
		cout << "High Priority Packets: " << count_HP << endl;
		cout << "AMAT Low Priority: " << (AMAT_LP / count_LP) << endl;
		cout << "Low Priority Packets: " << count_LP << endl;
		cout << "Weighted AMAT:" << (weightedAMAT/count) << endl;

/*
//for generating csv output
    fstream fout;
    fout.open("data.csv",ios::out|ios::app);
    fout<<load/num_of_nodes<<", ";
    fout<<double(total_latency)/double(message_completed)<<", ";
    fout<<double(message_completed)/double(final_time-initial_time)<<", ";
    //cout<<"Per VC Throughput and latency and messages :"<<" ";
    //fout<< (AMAT/count) <<", ";
    //fout<< (AMAT_LP / count_LP) <<", ";
    //fout<< (AMAT_HP / count_HP) <<", ";
    
    for(int i=0;i<4;i++)
    {
        fout<<double((per_vc_th[i]))/double(per_vc_endtime[i]-per_vc_starttime[i])<<", ";
        fout<<double(per_vc_lat[i])/double(per_vc_th[i])<<", ";
        fout<<per_vc_th[i]<<", ";
    }
    fout<<"\n";    
 
    cout<<"DEPARTURES\n";
    for (int i = 0; i < d_terminal[i].size(); i++)
    {   cout<<"for node"<<i<<"\n";
        for (int j = 0; j < d_terminal[i].size(); j++)
        {
            cout << d_terminal[i][j]->destination << " ";
            if(j%3==2){
                cout<<"\n";
            }
        }   
        cout << endl;
    }
    cout<<"ARRIVAL\n";
     for (int i = 0; i < a_terminal[i].size(); i++)
    {   cout<<"for node"<<i<<"\n";
        for (int j = 0; j < a_terminal[i].size(); j++)
        {
            cout << a_terminal[i][j]->source << " ";
            if(j%3==2){
                cout<<"\n";
            }
        }   
        cout << endl;
    }
    */
    
   /*
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
    }
*/
    }
    else
        cout << "Unable to open file";

    return 0;
}
