function ps_data = switch_demo(fig,ps_data,the_demo)

% function ps_data = switch_demo(fig,ps_data,the_demo)
%
% Function to get a demo matrix to compute the pseudospectra of

% Version 2.1 (Mon Mar 16 00:24:50 CDT 2009)
% Copyright 2002 - 2009 by Tom Wright; maintained by Mark Embree (embree@rice.edu)
%
% This is a slightly modified original Eigtool function included in Structured Eigtool.

%% Should we be using the fine or coarse grid?
    mnu_itm_h = findobj(fig,'Tag','FinerGrid');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      grid_size = 'F';
    else
      grid_size = 'C';
    end;

%% Extract the options code from the end of the input
%% Last character is matrix size (L)arge or (S)mall,
%% or (C)ode
    specific_opts = the_demo(end);
    the_demo = the_demo(1:end-1);

%% If we're just printing out the code, set a dummy matrix size
    if strcmp(specific_opts,'C'),
      mtx_size = 'S';
    else
      mtx_size = specific_opts;
    end;

% Get the parameters and name of the routine
    [N,opts,routine] = set_demo_params(mtx_size,grid_size,the_demo);
    
% Display the code for the routine, or actually execute it
    if strcmp('C',specific_opts),
      type(routine);
      disp('Press <RETURN> to continue...');
      return;
    else
%% Don't want the user to be able to press anything
      disable_controls(fig);

%% Display a message to reassure the user in case the matrix
%% takes some time to generate
      ps_data = update_messagebar(fig,ps_data,38);

%% Calculate the matrix
      mtx = feval(routine,N);
    end;

%% Now go away and set the GUI up for this matrix
    ps_data = new_matrix(mtx,fig.Number,opts);
