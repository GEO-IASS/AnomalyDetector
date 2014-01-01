function anomaly_visualizer(dataSize, dataAvg, anomalies, imputations, nodeNo)
% general purpose function for visualization of methods

    plot(dataAvg(1:dataSize),'r-'), hold on
    plot(imputations,'b--')

    anomalyPositions = [];
    for i=1:dataSize
        if anomalies(i) == 1, anomalyPositions = [anomalyPositions i]; end
    end
    scatter(anomalyPositions,zeros(size(anomalyPositions)), ...
        'k.', 'LineWidth',0.1)

    legend(nodeNo,'Imputations','Anomalies'), grid on

    plot(1:dataSize,zeros(1,dataSize),'k-')

    % set(gca,'xtick',1:6*24:dataSize)
    % set(gca, 'XTickLabel', 21:20+(dataSize+(6*24))/(6*24))
    ylim([-16 16])
    %hFig = figure(1);
    %set(hFig, 'Position', [100 500 1400 250])
    
    if strcmp(nodeNo,'Node 20')
        xlabel('Day from start of deployment')
        set(gca,'xtick',1:6*24:dataSize, ...
    'XTickLabel', 21:20+(dataSize+(6*24))/(6*24), 'FontSize',12)
    else
        set(gca,'xtick',1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
    end       
    
end
