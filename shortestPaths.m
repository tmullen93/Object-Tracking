function [best_match,frameDiffs] = shortestPaths( complist )
%1) Build graph from list of connected components
%2) Return shortest paths from first frame to lasts

K = size(complist,1);

% g = zeros(size(complist,1)*size(complist,3));
for k = 1:size(complist,3)-1
    frameDiffs(:,:,k) = pdist2(complist(:,:,k),complist(:,:,k+1));%[numframes*numfish numFrames]
end

for k =1:1:size(complist,3)-1
    [~, I] = min(frameDiffs(:,:,k),[],2);
    best_match(:,k) = I;
end




% for i = 1:size(g,1)-1
%     for j = 1:size(g,2)-1
%         if floor(j/K)==floor(i/K)+1
%             g(i,j) = frameDiffs(mod(i-1,K)+1,mod(j-1,K)+1,int8(ceil(i/K)));
%         end
%     end
% end


% g = digraph(g);
% % zero_nodes = []
% % for i =1:g.numnodes
% % %     i
% %     if indegree(g,i)==0 ||indegree(g,i)==0
% %         zero_nodes = [zero_nodes i]; 
% %     end
% % end
% g=g.rmnode(zero_nodes)
% plot(g,'EdgeLabel',g.Edges.Weight)



end

