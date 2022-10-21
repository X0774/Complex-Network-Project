l=0;
B=zeros(StarSample,3);
mag=table2array(data(1:StarSample,15));
mag2=zeros(StarSample,1);
Degree2=zeros(StarSample,1);
Betweennes2=zeros(StarSample,1);
Closeness2=zeros(StarSample,1);
Page_rank2=zeros(StarSample,1);
for i=1:StarSample 
    if (A(i,1)>9*10) & (A(i,1)<2*10e3) & (A(i,2)>9*10) & (A(i,2)<2*10e3) & (A(i,3)>9*10) & (A(i,3)<2*10e3) 
        l=l+1;
        B(l,1)=A(i,1);
        B(l,2)=A(i,2);
        B(l,3)=A(i,3);
        Degree2(l)=Degree(i);
        Page_rank2(l)=Page_rank(i);
        Closeness2(l)=Closeness(i);
        Betweennes2(l)=Betweennes(i);
        mag2(l)=mag(i);
        %disp(l);
    end
end

Adj2=zeros(l,l); % in this way diagonal elements are already zero
for c=1:l %StarSample is a dummy number
    for i=c+1:l 
        dist=0;
        for k=[1,3]
            dist=dist+(B(c,k)-B(i,k))^2; %dist is the square of distance between two stars
            if dist<SampleLength  % samplelenght is the square of the sample lenght
                Adj2(c,i)=1;
                Adj2(i,c)=1;
            end
        end
    end
end

G=graph(Adj2);

DegreeN = centrality(G,'degree');
ClosenessN = centrality(G, 'closeness');
BetweennesN = centrality(G, 'betweenness');
Page_rankN = centrality(G, 'pagerank');

num=0;
for i=1:l
    if (DegreeN(i)==0)
        Adj2(i-num,:)=[];
        Adj2(:,i-num)=[];
        mag2(i)=[];
        num=num+1;
    end
end

G=graph(Adj2);

DegreeN = centrality(G,'degree');
ClosenessN = centrality(G, 'closeness');
BetweennesN = centrality(G, 'betweenness');
Page_rankN = centrality(G, 'pagerank');
length=l-num;

figure
histogram(DegreeN);
figure
scatter(DegreeN,BetweennesN);

Y=cmdscale(Adj2,3); 
figure
scatter3(B(1:l,1),B(1:l,2),B(1:l,3));
figure
scatter3(Y(:,3),Y(:,2),Y(:,1));
