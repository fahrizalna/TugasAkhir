#ifndef aodv_kmeans_h
#define aodv_kmeans_h

#include <vector>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <aodv/aodv.h>

struct point{
    double x;
    double y;
};

class Member {
    private:
        int index;
        struct point position;
        double nearestDistance;
    public:
        Member();
        struct point getMemberPoint();
        void setNearestDistance(double nearestDistance);
        double getNearestDistance();
        void setMemberPoint(struct point pt);
        void setMemberIndex(int index);
        double getMemberPointX();
        double getMemberPointY();
        int getMemberIndex();
};

#define MAX_X 900
#define MAX_Y 900

class Cluster{
    private:
        struct point centroid;
    public:
        Cluster();
        void init();
        std::vector <Member> members;
        void assignMember(Member member);
        void unassignMember(int index);
        Member getMember(int index);
        Member getClusterHead();
        Member getClusterGateway(struct point center);
        void updateCentroid();
        struct point getCentroid();
        int getSize();
};

class KMeans {
    private:
        std::vector <Cluster> clusters;
    public:
        KMeans();
        void run();
        void assignCluster(Cluster cluster);
        struct nodes_clusters_table getResult();
};

#endif