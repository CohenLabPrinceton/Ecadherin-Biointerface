function quick_signal_test(TRITCsignal,GFPsignal)

figure;
for(k=1:20)
    subplot(5,4,k);
    kk=randi(size(TRITCsignal,2));
    G1=TRITCsignal(:,kk); 
    G2=GFPsignal(:,kk);
    
    
    plot(G1,'r');
    hold on;
    plot(G2,'g');
    
end

end
