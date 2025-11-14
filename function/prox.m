function X_fista = prox(y_para,lambda_para,mode)
% --------------------------------------------------------------------
% Input:
%       - y_para, input variable before iteration
%       - lambda_para, input parameter
%       - mode: Non-Negativity Constraint (true/false)
%
% Output:
%       - X_fista, output variable after iteration
%
%---------------------------------------------------------------------
% Author: Jingyao Sun, sunjy22@mails.tsinghua.edu.cn
% Date created: July-30-2024
% @Tsinghua Univertity.
% --------------------------------------------------------------------

dim = length(y_para);
Y = y_para;
D = eye(dim);
opts.pos = mode;
opts.lambda = lambda_para;
opts.backtracking = false;
X_fista = fista_lasso(Y,D,[],opts);

end