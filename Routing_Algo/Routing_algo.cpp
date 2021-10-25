#include<iostream>
#include<limits.h>
#include"parser.cpp"
using namespace std;

#define Routers 6

int min_Distance(int dist[],bool s[])
{
	int min=INT_MAX;
	int min_index;

	for (int v=0; v <Routers;v++)
	{
		if(s[v]==false && dist[v] <=min)
		{
			min=dist[v];
			min_index=v;
		}
	}

	return min_index;
}


void path(int source[],int k)
{
	if(source[k]==-1)
	{
		return;
	}
	path(source,source[k]);
	printf("%d",k);
}
void output(int dist[],int source[])
{
	int src=0;
	for(int i=1;i<Routers;i++)
	{
		printf("\n%d->%d \t %d  %d",src,i,dist[i],src);
		path(source,i);
	}
}


void dijkstra(vector<vector<int>> vec_2d, int src)
{
	int source[Routers];
	int dist[Routers];
	bool s[Routers];


	for(int i=0;i< Routers;i++)
	{
		source[i]=-1;
		dist[i]=INT_MAX;
		s[i]=false;
	}
	dist[src]=0;
	for(int c=0;c<Routers-1;c++)
	{
		int u=min_Distance(dist,s);
		s[u]=true;

		for(int v=0;v<Routers;v++)
		{
			if(!s[v] && vec_2d[u][v] && dist[u] !=INT_MAX
					&& dist[u] +vec_2d[u][v] < dist[v])
			{
				source[v]=u;
				dist[v]=dist[u]+vec_2d[u][v];
			}
		}
	}
	
	output(dist,source);
	
}


int main()
{
	vector<vector<int>> vec_2d=parser();

	printf("%d",vec_2d[0].size());	
	for(int i=0;i<vec_2d.size();i++)
	{
		for(int j=0;j<vec_2d[i].size();j++)
		{
			cout<<vec_2d[i][j];
		}
		cout<<"\n";
	}
	dijkstra(vec_2d,0);
	return 0;
}
