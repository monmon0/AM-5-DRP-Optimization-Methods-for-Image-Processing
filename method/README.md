# AM-5 DRP Denoising Signals

## Description
The following script aim to solve the least square problem for Ridge regression (scheme 1).
The function can be call to solve the problem when given the parameters:
- u: estimated signal (1 x n matrix)
- u_true: corrupted signam (1 x n matrix)
- lambda: hyperparameter that is specified by caller, denoting the rapidly varying component


### Executing program

You can follow the following format to solve the Least Square problem and thus use the answer for plotting
```
[u_denoised, u_true] = solveL2_1Dsignal(u,u_true, lambda);
```
where the parameters are explained as above.

