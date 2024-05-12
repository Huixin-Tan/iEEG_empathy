function PC = compute_PC(data1, data2)

%% data1: time seris 1
%% data2: time seris 2

  PC = corr(data1,data2,'type','spearman');
  % Fisher-z-transformed
  PC = atanh(PC);
  
end