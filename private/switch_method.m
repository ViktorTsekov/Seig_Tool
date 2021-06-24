function ps_data = switch_method(fig,cax,this_ver,ps_data,btn,set_only)

% function ps_data = switch_method(fig,cax,this_ver,ps_data,btn)
%
% Function called when one of the structure radio buttons
% are chosen.

% Version 2.1 (Mon Mar 16 00:24:50 CDT 2009)
% Copyright 2002 - 2009 by Tom Wright; maintained by Mark Embree (embree@rice.edu)
%
% This is a modified original Eigtool function included in Structured Eigtool.

     [m,n] = size(ps_data.input_matrix);


       if isfield(ps_data,'schur_matrix'),
         ps_data.matrix = ps_data.schur_matrix;
         ps_data.ews = ps_data.orig_ews;
% These are not estimates, so should be plotted in black
         ps_data.ew_estimates = 0;
% If we have a sparse, square matrix, get rid of any ARPACK compression
       elseif m==n & issparse(ps_data.input_matrix),
         ps_data.matrix = ps_data.input_matrix;
       end;
       
       
% If there is a unitary matrix from the Schur decomposition, use that
% Otherwise, use the unitary matrix (optionally) input by the user
       if isfield(ps_data,'schur_unitary_mtx'),
         ps_data.unitary_mtx = ps_data.input_unitary_mtx*ps_data.schur_unitary_mtx;
       else
         ps_data.unitary_mtx = ps_data.input_unitary_mtx;
       end;
       ps_data.proj_valid = 0;

% If we're reverting to a square matrix, no longer have ARPACK projection
       ss = size(ps_data.matrix);
       if ss(1)==ss(2), ps_data.isHessenberg = 0; end;
      
       state = 'off';


% Set the radio buttons correctly

     if strcmp(btn,'unstructured'), 
        set(findobj(fig,'Tag','unstructured'),'value',  1);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
        ps_data.structure='unstructured';
     elseif strcmp(btn,'real'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          1);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
        ps_data.structure='real';
     elseif strcmp(btn,'skew-symmetric'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',1);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
        ps_data.structure='skew-symmetric';
     elseif strcmp(btn,'Hermitian'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     1);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
        ps_data.structure='Hermitian';
     elseif strcmp(btn,'Hamiltonian'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   1);
        ps_data.structure='Hamiltonian';
     end
     
% Enable the Go button
     if nargin<6 | set_only==0,
       ps_data = update_messagebar(fig,ps_data,33,1);
       ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
     end;
