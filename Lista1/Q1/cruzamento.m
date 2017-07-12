function Pnew=cruzamento(P,S,Pc,a);
% selecao de individuos pelo metodo do sorteio

n=size(P);

Pnew=[];
for i=1:n(1)/2,
    u=rand;
    if u<=Pc,
	    % Determina ponto de corte aleatoriamente
    	    
    	    % Determina filhos
            Pai1 = P(S(i,1),:);
            Pai2 = P(S(i,2),:);
            c = -a;
            d = 1+a;
            r = (d-c).*rand(1) + c;
    	    F1=Pai1+r*(Pai2-Pai1); 
            r = (d-c).*rand(1) + c;
    	    F2=Pai2+r*(Pai1-Pai2);
            %F1=(Pai1+Pai2)/2;
            %F2=(Pai1+Pai2)/2;
    
	        Pnew=[Pnew;F1;F2];
    else
	    % Determina filhos
    	    F1=P(S(i,1),:);
    	    F2=P(S(i,2),:);
    
	        Pnew=[Pnew;F1;F2];
    end
end
    
