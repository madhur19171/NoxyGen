// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;
struct dep_packets
{
    long message_dep;
    long destination;
    long departure;
};

struct arr_packets
{
    long message_arr;
    long source;
    long arrival;
};

int main()
{
    string line;
    ifstream myfile("Stats.txt");
    /*vector<vector<int>> dep;
    vector<vector<int>> arr;*/
    //Uncomment to move to sliding-window based implementation
    vector<vector<dep_packets *>> d_terminal;
    vector<vector<arr_packets *>> a_terminal;
    int num_of_nodes = 9; //Requires manual intervention
    for (int id = 0; id < num_of_nodes; id++)
    {
        /*vector<int> vald;
        vector<int> vala;
        dep.push_back(vald);
        arr.push_back(vala);*/
        //Uncomment to move to sliding-window based implementation
        vector<dep_packets *> samd;
        d_terminal.push_back(samd);
        vector<arr_packets *> sama;
        a_terminal.push_back(sama);
    }

    if (myfile.is_open())
    {
        while (getline(myfile, line))
        {
            if (line.find("Departure") != string::npos)
            {
                //means it is sender
                string source = line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") - 5);
                //cout<<source<<"ssss\n";
                int source_i = stol(source);
                //cout<<"source"<<source_i<<"\n";
                //cout << line.substr(line.find("e: ") + 2, line.find("Des") - line.find("e: ") - 3) << "\n";
                string message_ds = line.substr(line.find("ge: ") + 4, line.find("Des") - line.find("ge: ") - 3); //<<"\n";
                int message_d = stol(message_ds);
                //cout<<message_ds<<"sssssssssssssss\n";
                string destination_ds = line.substr(line.find("n: ") + 2, line.find("Dep") - line.find("n: ") - 3);
                int destination_d = stol(destination_ds);
                //cout<<destination_d<<"sdsd\n";
                string departure_ds = line.substr(line.find("me: ") + 4, line.length() - line.find("me: "));
                //cout<<departure_ds<<"sddsd\n";
                int departure_d = stol(departure_ds);
                //vector<int> curr_data={message_d,destination_d,departure_d};
                /*dep[source_i].push_back(message_d);
                dep[source_i].push_back(destination_d);
                dep[source_i].push_back(departure_d);*/
                //Uncomment to move to sliding-window based implementation
                dep_packets *outgoing = new dep_packets;
                outgoing->message_dep = message_d;
                outgoing->destination = destination_d;
                outgoing->departure = departure_d;

                d_terminal[source_i].push_back(outgoing);

                //cout << line << "\n";
            }
            else if (line.find("Arrival") != string::npos)
            {
                //means it is receiver

                string destination = line.substr(line.find("de:") + 5, line.find("Mes") - line.find("de:") - 7);
                //cout<<destination<<"ssss\n";
                int destination_i = stol(destination);
                //cout<<"source"<<destination_i<<"\n";//cprrect

                //cout << line.substr(line.find("ge: ") + 2, line.find("Sour") - line.find("ge: ") - 3) << "\n";
                string message_as = line.substr(line.find("ge: ") + 4, line.find("Sour") - line.find("ge: ") - 5); //<<"\n";
                int message_a = stol(message_as);
                //cout<<message_a<<"mess\n";
                string source_as = line.substr(line.find("ce: ") + 4, line.find("Arr") - line.find("ce: ") - 5);
                int source_a = stol(source_as);
                //cout<<source_as<<"sdsd\n";
                string arrival_as = line.substr(line.find("me: ") + 4, line.length() - line.find("me: "));
                //cout<<arrival_as<<"sddsd\n";
                int arrival_a = stol(arrival_as);
                //vector<int> curr_data={message_a,source_a,arrival_a};
                /*arr[destination_i].push_back(message_a);
                arr[destination_i].push_back(source_a);
                arr[destination_i].push_back(arrival_a);*/
                //Uncomment to move to sliding-window based implementation
                arr_packets *incoming = new arr_packets;
                incoming->message_arr = message_a;
                incoming->source = source_a;
                incoming->arrival = arrival_a;
                a_terminal[destination_i].push_back(incoming);
            }
        }
        myfile.close();
        //Uncomment to move to sliding-window based implementation
        /*cout << "DEPARTURES\n";
        for (int i = 0; i < dep.size(); i++)
             {
            cout << "for node" << i << "\n";
            for (int j = 0; j < dep[i].size(); j++)
            {
                cout << dep[i][j] << " ";
                if(j%3==2){
                cout<<"\n";
            }
            }
            cout << endl;
        }*/
        /*cout << "ARRIVAL\n";
        for (int i = 0; i < arr.size(); i++)
        {
            cout << "for node" << i << "\n";
            for (int j = 0; j < arr[i].size(); j++)
            {
                cout << arr[i][j] << " ";
                /*if(j%3==2){
                cout<<"\n";
            }
            }
            cout << endl;
        }*/

        for (int i = 0; i < 9; i++)
        {
            cout << "Node" << i << "\n";
            for (int j = 0; j < d_terminal[i].size(); j++)
            {
                cout << d_terminal[i][j]->message_dep << " " << d_terminal[i][j]->destination << " " << d_terminal[i][j]->departure;
                cout << "\n";
            }
        }
        cout << "ARRIVAL\n";
        for (int i = 0; i < 9; i++)
        {
            cout << "Node " << i << "\n";
            for (int j = 0; j < a_terminal[i].size(); j++)
            {
                cout << a_terminal[i][j]->message_arr << " " << a_terminal[i][j]->source << " " << a_terminal[i][j]->arrival;
                cout << "\n";
            }
        }
    }

    else
        cout << "Unable to open file";

    return 0;
}
