// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

int main()
{
    
    string line;
    ifstream myfile("Stats.txt");
    vector<vector<int>> dep;
    vector<vector<int>> arr;
    int num_of_nodes = 9;
    for (int id = 0; id < num_of_nodes; id++)
    {
        vector<int> vald;
        vector<int> vala;
        dep.push_back(vald);
        arr.push_back(vala);
    }

    if (myfile.is_open())
    {
        while (getline(myfile, line))
        {
            if (line.find("Departure") != string::npos)
            {
                //means it is sender
               string source=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -5);
                //cout<<source<<"ssss\n";
                int source_i=stoi(source);
                //cout<<"source"<<source_i<<"\n";
                //cout << line.substr(line.find("e: ") + 2, line.find("Des") - line.find("e: ") - 3) << "\n";
                string message_ds = line.substr(line.find("ge: ") + 4, line.find("Des") - line.find("ge: ") - 3); //<<"\n";
                int message_d = stoi(message_ds);
                //cout<<message_ds<<"sssssssssssssss\n";
                string destination_ds = line.substr(line.find("n: ") + 2, line.find("Dep") - line.find("n: ") - 3);
                int destination_d=stoi(destination_ds);
                //cout<<destination_d<<"sdsd\n";
                string departure_ds = line.substr(line.find("me: ")+4, line.length() - line.find("me: "));
                //cout<<departure_ds<<"sddsd\n";
                int departure_d=stoi(departure_ds);
                //vector<int> curr_data={message_d,destination_d,departure_d};
                dep[source_i].push_back(message_d);
                dep[source_i].push_back(destination_d);
                dep[source_i].push_back(departure_d);



                //cout << line << "\n";
            }
            else if (line.find("Arrival") != string::npos)
            {
                //means it is receiver
                //cout<<"aaa";
                string destination=line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") -7);
                //cout<<destination<<"ssss\n";
                int destination_i=stoi(destination);
                //cout<<"source"<<destination_i<<"\n";//cprrect


                //cout << line.substr(line.find("ge: ") + 2, line.find("Sour") - line.find("ge: ") - 3) << "\n";
                string message_as = line.substr(line.find("ge: ") + 4, line.find("Sour") - line.find("ge: ") - 5); //<<"\n";
                int message_a = stoi(message_as);
                //cout<<message_a<<"mess\n";
                string source_as = line.substr(line.find("ce: ") + 4, line.find("Arr") - line.find("ce: ") - 5);
                int source_a=stoi(source_as);
                //cout<<source_as<<"sdsd\n";
                string arrival_as = line.substr(line.find("me: ")+4, line.length() - line.find("me: "));
                //cout<<arrival_as<<"sddsd\n";
                int arrival_a=stoi(arrival_as);
                //vector<int> curr_data={message_a,source_a,arrival_a};
                arr[destination_i].push_back(message_a);
                arr[destination_i].push_back(source_a);
                arr[destination_i].push_back(arrival_a);
            }
        }
        myfile.close();

                
        cout<<" Negative time => packets not routed to destination\n\n\n";
        for(int i=0;i<dep.size();i++)
        {    
            int source;
            int dest;
            int dept;
            int arrv;
            int messg;

            for(int j=0;j < dep[i].size();j=j+3)
            {
             source=i;
             dest=dep[i][j+1];
             dept=dep[i][j+2];
             messg=dep[i][j];
             arrv;
             int routed=0;
            for(int k=0;k<arr[dest].size();k=k+3)
            {
                if(arr[dest][k]==messg && arr[dest][k+1]==source)
                {
                    routed=1;
                    arrv=arr[dest][k+2];
                    break;
                }
            }
            if(routed==0)
            {
                arrv=0;
            }
            cout<<"Message "<<messg<<" from "<<source<<" to "<<dest<<" in time "<<arrv-dept<<"\n";
            }
        }
    cout<<"Debug output\n\n";
    cout<<"DEPARTURES\n";
    for (int i = 0; i < dep.size(); i++)
    {   cout<<"for node"<<i<<"\n";
        for (int j = 0; j < dep[i].size(); j++)
        {
            cout << dep[i][j] << " ";
            if(j%3==2){
                cout<<"\n";
            }
        }   
        cout << endl;
    }
    cout<<"ARRIVAL\n";
     for (int i = 0; i < arr.size(); i++)
    {   cout<<"for node"<<i<<"\n";
        for (int j = 0; j < arr[i].size(); j++)
        {
            cout << arr[i][j] << " ";
            if(j%3==2){
                cout<<"\n";
            }
        }   
        cout << endl;
    }


    }

    else
        cout << "Unable to open file";

    return 0;
}
