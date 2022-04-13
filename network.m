
%% SETTING PARAMETERS

clear
n_rip=10; %numero ripetizioni ciclo per diversi valori di x
n=1
StarSample=1000;



%% READING DATA

    data = readtable('hygdata_v3.csv');
%disp(data(1:5,18:20)); % check - in the database xyz are 18,19,20 column

    A=table2array(data(1:StarSample,18:20));
%scatter3(A(:,1),A(:,2),A(:,3));


for i=1:n_rip
    x=10^i/10^6; %% x scala a step di 10, parte da 10^-5 e arriva a 10^(n_rip -6)
    SampleLength=(100*x*0.3)^2; %the idea is that a big cloud has 100 LY diameter, 0.3 is a parsec conversion, x a scaling factor
    dist=0; %We initialize variables

%% BUILDING ADJACENCY MATRIX

    Adj=zeros(StarSample,StarSample); % in this way diagonal elements are already zero

    for c=1:StarSample %StarSample is a dummy number
        for i=c+1:StarSample 
            dist=0;
            for k=[1,3]
                dist=dist+(A(c,k)-A(i,k))^2; %dist is the square of distance between two stars
                if dist<SampleLength  % samplelenght is the square of the sample lenght
                    Adj(c,i)=1;
                    Adj(i,c)=1;
                else
                    Adj(c,i)=0;
                    Adj(i,c)=0;
              end
            end
        end
    end

    G=graph(Adj);
%plot(G);

%% CENTRALITY AT DIFFERENT X

    Degree(n,:) = centrality(G,'degree');
    Closeness(n,:) = centrality(G, 'closeness');
    Betweennes(n,:) = centrality(G, 'betweenness');
    Page_rank(n,:) = centrality(G, 'pagerank');
n=n+1
end

%% LAPLACIAN CREATED HERE
%{
K = diag(sum(Adj));
L = K-Adj;
[Vec Val] = eig(L);
%}