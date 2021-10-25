#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;
vector<vector<int>> parser()
{
    string myText;

    ifstream MyReadFile("sample.dot");
    string dot_grf = "";

    while (getline(MyReadFile, myText))
    {
        dot_grf.append(myText);
        //cout << myText;
    }
    //cout << dot_grf;
    int pointer_count = 0;
    //cout << (myText.length());
    vector<int> vect;
    vector< vector<int> > v;
    vector< vector<int> > mat;
    for(int i1=0;i1<6;i1++){
        vector<int> mat_v(6, 0);
        mat.push_back(mat_v);
    }

   /* for (int j2=0;j2<6;j2++){
        //cout<<j<<" is conecteed to ";
        for(int j3=0;j3<6;j3++){
            
            cout<<mat[j2][j3]<<" ";
        }
        cout<<'\n';
    }*/
    
    //int mat[5][5]={0};
    for (int i = 0; i < dot_grf.length(); i++)
    {
        //cout << dot_grf[i];
        if (dot_grf[i] == '-' && dot_grf[i + 1] == '>')
        {
            pointer_count++;
            int index=dot_grf[i-2]-'0';
           //cout<<index;
            int b_first=i+3;
            vector<int> data_v;
            while(dot_grf[b_first]!='}'){
                b_first++;
                
                if(dot_grf[b_first]>='0' && dot_grf[b_first]<='9'){
                    int data=dot_grf[b_first]-'0';
                   // cout<<' '<<dot_grf[b_first]-'0';
                    data_v.push_back(data);
                    mat[index][data]=1;

                    //v[index].push_back(dot_grf[b_first]-'0');
                    
                }
                
            }
             v.push_back(data_v);
           // cout<<'\n';
            //cout<<dot_grf[i-2]-'0';
            //vect.push_back(dot_grf[i-2]-'0');
        }
    }
    //cout << pointer_count<<'\n';
    /*for (int j=0;j<v.size();j++){
        //cout<<j<<" is conecteed to ";
        for(int j1=0;j1<v[j].size();j1++){
            
            cout<<v[j][j1]<<" ";
        }
        cout<<'\n';
    }*/

    /*for (int j2=0;j2<6;j2++){
        //cout<<j<<" is conecteed to ";
        for(int j3=0;j3<6;j3++){
            
            cout<<mat[j2][j3]<<" ";
        }
        cout<<'\n';
    }*/

    
    
    

    MyReadFile.close();
    return mat;
}
