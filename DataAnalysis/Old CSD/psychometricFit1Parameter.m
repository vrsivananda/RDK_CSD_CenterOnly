% alpha  = bias / mean / threshold / PSE
% beta   = slope = 1/sigma
% p(1)   = k = scaling factor
% gamma  = guess rate = 0
% lambda = lapse rate = 0

function output = psychometricFit1Parameter(x,y,alpha,beta,subjNum,condition,save)


    %   y  =        0.5*(erfc(-((1/k)   .*beta).*(x-alpha)./sqrt(2)));
    psyFit = @(p,a) 0.5*(erfc(-((1/p(1)).*beta).*(a-alpha)./sqrt(2)));
    
    %Get an estimate of the parameters from the function and guess values
    pEst = nlinfit(x,y,psyFit,1); %1 is the initial value for k
    %Create detailed points of x for smooth sigmoid curve
    newX = linspace(-1,1,40);
    %Make an long array of estimated y values based on the parameters above
    y_pred = psyFit(pEst,newX);
%     
%     %hold the previous figure
%     figure;
%     %Plot the original values with large blue dots
%     plot(x,y,'b.','MarkerSize',20);
%     %label and title the plot
%     ylabel('Confidence Judgment');
%     xlabel('Left              <---     Coherence     --->              Right');
%     title('Confidence Function: k is free parameter');
%     xlim([-1 1]);
%     ylim([0 1]);
%     
%     
%     %Hold so that another plot can go over the same figure
%     hold on;
%     %Plot the predicted values based on the psychometric function
%     plot(newX,y_pred,'r.--','LineWidth',2,'MarkerSize',1);
%     %Add the legend
%     legend('Data','Model Fit','Location','northwest');
%     
%     %Save the figure
%     if(save == 1)
%         fileName = ['Expt2_Subject' num2str(subjNum) '_Condition' num2str(condition) '.png'];
%         saveas(gcf,fileName);
%     end
%     
    %Output k
    output = pEst;
end
