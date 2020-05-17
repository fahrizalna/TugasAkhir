#include "aodv_kmeans.h"

// General //

double distanceMemberToCentroid(Member member, struct point centroid)
{
    double result = 0.0;
    double resultX = pow(member.getMemberPointX() - centroid.x, 2);
    double resultY = pow(member.getMemberPointY() - centroid.y, 2);
    result = sqrt(resultX+resultY);
    return result;
}

// Member //

Member::Member()
{
    this->nearestDistance = 100000.00;
}

void Member::setNearestDistance(double nearestDistance)
{
    this->nearestDistance = nearestDistance;
}

double Member::getNearestDistance()
{
    return this->nearestDistance;
}

void Member::setMemberPoint(struct point pt)
{
    this->position = pt;
}

struct point Member::getMemberPoint()
{
    return this->position;
}

double Member::getMemberPointX()
{
    return this->position.x;
}

double Member::getMemberPointY()
{
    return this->position.y;
}

int Member::getMemberIndex()
{
    return this->index;
}

void Member::setMemberIndex(int index)
{
    this->index = index;
}


// Cluster

Cluster::Cluster()
{
}

void Cluster::init()
{
    this->centroid.x = rand() % MAX_X;
    this->centroid.y = rand() % MAX_Y;
}

void Cluster::assignMember(Member member)
{
    this->members.push_back(member);
}

void Cluster::unassignMember(int index)
{
    int iter=0;
    for(int i=0;i<this->members.size();i++)
    {
        if(this->members[i].getMemberIndex() == index)
        {
            this->members.erase(this->members.begin()+iter);
            return;
        }
        iter++;
    }
}

void Cluster::updateCentroid()
{
    double xCount,yCount,zCount;
    int membersSize = this->members.size();
    if(membersSize==0)return;
    for(int i=0;i<membersSize;i++)
    {
        xCount+=this->members[i].getMemberPointX();
        yCount+=this->members[i].getMemberPointY();
    }
    this->centroid.x = xCount/membersSize;
    this->centroid.y = yCount/membersSize;
}

struct point Cluster::getCentroid()
{
    return this->centroid;
}

int Cluster::getSize()
{
    return this->members.size();
}

Member Cluster::getMember(int index)
{
    for(int i=0;i<this->members.size();i++)
    {
        if(this->members[i].getMemberIndex() == index)
            return this->members[i];
    }
    Member member;
    return member;
}

Member Cluster::getClusterHead()
{
    struct point center = this->getCentroid();
    double nearestDistance = 1000000.00;
    int iter=0;
    for(int i=0;i<this->members.size();i++)
    {
        double temp = distanceMemberToCentroid(members[i],center);
        if(temp<nearestDistance)
        {
            nearestDistance=temp;
            iter=i;
        }
    }
    return members[iter];
}

Member Cluster::getClusterGateway(struct point clustersCenter)
{
    double nearestDistance = 1000000.00;
    int iter=0;
    for(int i=0;i<this->members.size();i++)
    {
        double temp = distanceMemberToCentroid(members[i],clustersCenter);
        if(temp<nearestDistance)
        {
            nearestDistance=temp;
            iter=i;
        }
    }
    return members[iter];
}

//KMeans

KMeans::KMeans()
{}

void KMeans::assignCluster(Cluster cluster)
{
    this->clusters.push_back(cluster);
}

void KMeans::run()
{
    bool change = true;

    while(change)
    {
        change = false;
        //check every member in cluster to each centroid of clusters
        for(int i=0;i<this->clusters.size();i++)
        {
            for(int j=0;j<this->clusters[i].members.size();j++)
            {
                int currentClusterIndex=i;
                int nextClusterIndex=i;
                int nodeIndex = clusters[i].members[j].getMemberIndex();
                for(int k=0;k<this->clusters.size();k++)
                {
                    double temp = distanceMemberToCentroid(clusters[i].members[j],clusters[k].getCentroid());
                    //shorter distance is found
                    if(temp<clusters[i].members[j].getNearestDistance())
                    {
                        clusters[i].members[j].setNearestDistance(temp);
                        nextClusterIndex = k;
                    }
                }
                //changing of member cluster
                if(currentClusterIndex != nextClusterIndex)
                {
                    Member member = clusters[currentClusterIndex].getMember(nodeIndex);
                    clusters[currentClusterIndex].unassignMember(nodeIndex);
                    clusters[nextClusterIndex].assignMember(member);
                    change = true;
                }
            }
        }
        //update centroid
        for(int i=0;i<this->clusters.size();i++)
        {
            this->clusters[i].updateCentroid();
        }
    }
}

struct nodes_clusters_table KMeans::getResult()
{
    struct nodes_clusters_table ct;
    memset(ct.nodes_cluster_head,-1,sizeof(ct.nodes_cluster_head));
    memset(ct.nodes_cluster_gateway,-1,sizeof(ct.nodes_cluster_gateway));
    for(int i=0;i<this->clusters.size();i++)
    {
        if(clusters[i].getSize() != 0)ct.nodes_cluster_head[i] = clusters[i].getClusterHead().getMemberIndex();
    }

    struct point center;
    double cX,cY;
    for(int i=0;i<this->clusters.size();i++)
    {
        for(int j=0;j<this->clusters[i].getSize();j++)
        {
            cX+=clusters[i].members[j].getMemberPointX();
            cY+=clusters[i].members[j].getMemberPointY();
        }
    }

    center.x = cX/NUMBER_OF_NODE;
    center.y = cY/NUMBER_OF_NODE;
    for(int i=0;i<this->clusters.size();i++)
    {
        if(clusters[i].getSize() != 0)ct.nodes_cluster_gateway[i] = clusters[i].getClusterGateway(center).getMemberIndex();
    }

    ct.nodes_cluster_timestamp = CURRENT_TIME;
    return ct;
}