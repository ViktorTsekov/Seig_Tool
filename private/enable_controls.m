function enable_controls(fig,ps_data)

% function enable_controls(fig,ps_data)
%
% Function to enable the controls on the GUI

% Version 2.1 (Mon Mar 16 00:24:49 CDT 2009)
% Copyright 2002 - 2009 by Tom Wright; maintained by Mark Embree (embree@rice.edu)
%
% This is a modified original Eigtool function included in Structured Eigtool.

  if isfield(ps_data,'projection_on'), projection_on = ps_data.projection_on;
  else projection_on = 0; end;
  if isfield(ps_data,'input_matrix'),
    [mmm,nnn] = size(ps_data.input_matrix);
  else
    mmm=0; nnn=0;
  end;
  [mm,nn] = size(ps_data.matrix);
  if isfield(ps_data,'projection_on'), 
    enable_ewcond = (((mm==nn) | ps_data.isHessenberg) & ~isempty(ps_data.ews));
    enable_psmode = (((mm==nn) | ps_data.isHessenberg) & ~isempty(ps_data.unitary_mtx));
  else
    enable_ewcond = 0;
    enable_psmode = 0;
  end;

% Always enable all of the menus (except ARPACK, which depends on comp mode)
  the_handle = findobj(fig,'Tag','FileMenu'); 
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','DemosMenu'); 
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','WindowMenu'); 
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','Quit');
  set(the_handle,'backgroundcolor',[0.702 0.705 0.702]);  % mpe addition: keeps button rectangular
  set(the_handle,'Enable','on');

  the_handle = findobj(fig,'Tag','Import');
  set(the_handle,'Enable','on');

  the_handle = findobj(fig,'Tag','DepartureNormality');
  if isfield(ps_data,'schur_matrix'),
    set(the_handle,'Enable','on');
  else  
    set(the_handle,'Enable','off');
  end;


% If there is no zoom_list field of ps_data, only the following buttons
% should be allowed (the GUI is prompting for a matrix to work with)
if ~isfield(ps_data,'zoom_list'),

  set_menu_itms(fig,'off');

% Computation was in progress, now stopped, and we're in ARPACK mode
elseif isfield(ps_data,'comp_stopped') & strcmp(ps_data.comp_stopped,'ARPACK')
  enable_arpack(fig,ps_data);
  set_menu_itms(fig,'off');
  the_handle = findobj(fig,'Tag','ExtrasMenu'); 
  set(the_handle,'Enable','on');

% Computation was in progress, now stopped, and we're in non-ARPACK mode
elseif isfield(ps_data,'comp_stopped') & strcmp(ps_data.comp_stopped,'PSA')
  enable_edit_axes(fig);
  set_menu_itms(fig,'off');
  the_handle = findobj(fig,'Tag','meshsize');
  set(the_handle,'Enable','on');
  if projection_on==1,
    the_handle = findobj(fig,'Tag','Safety');
    set(the_handle,'Enable','on');
  end;
  enable_arpack(fig,ps_data);
  the_handle = findobj(fig,'Tag','ExtrasMenu'); 
  set(the_handle,'Enable','on');

% Enable click/drag in axes again
  if isfield(ps_data,'zoom_list'),
    if isfield(ps_data.zoom_list{ps_data.zoom_pos},'Z') ... 
       & ~isempty(ps_data.zoom_list{ps_data.zoom_pos}.Z),
      set(fig,'WindowButtonDownFcn','eigtool_switch_fn(''PsArea'');');
    end;
  end;

% In general use mode - no computation going on
else

  the_handle = findobj(fig,'Tag','ExtrasMenu'); 
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','NumbersMenu'); 
  set(the_handle,'Enable','on');
  set_numbersmenu_itms(fig,ps_data);

  set_menu_itms(fig,'on');

%% Enable the axes.
  enable_edit_axes(fig);
  
%% Enable choosing (un)structured computations
   the_handle = findobj(fig,'Tag','unstructured');
   set(the_handle,'Enable','on');
   if mmm==nnn,
      the_handle = findobj(fig,'Tag','real');
      set(the_handle,'Enable','on');
      the_handle = findobj(fig,'Tag','skew-symmetric');
      set(the_handle,'Enable','on');
      the_handle = findobj(fig,'Tag','Hermitian');
      set(the_handle,'Enable','on');
      if ~mod(nnn,2),
          the_handle = findobj(fig,'Tag','Hamiltonian');
          set(the_handle,'Enable','on');
      end
   end
   

%% Set the radio buttons correctly

    if ~isfield(ps_data,'structure') 
        set(findobj(fig,'Tag','unstructured'),'value',  1);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
     elseif strcmp(ps_data.structure,'real'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          1);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
     elseif strcmp(ps_data.structure,'skew-symmetric'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',1);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
     elseif strcmp(ps_data.structure,'Hermitian'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     1);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   0);
     elseif strcmp(ps_data.structure,'Hamiltonian'), 
        set(findobj(fig,'Tag','unstructured'),'value',  0);
        set(findobj(fig,'Tag','real'),'value',          0);
        set(findobj(fig,'Tag','skew-symmetric'),'value',0);
        set(findobj(fig,'Tag','Hermitian'),'value',     0);
        set(findobj(fig,'Tag','Hamiltonian'),'value',   1);
     end
   
   

% If we're not in the middle of an ARPACK computation, can enable
% most things...
  if strcmp(ps_data.comp,'ARPACK')~=1,
    the_handle = findobj(fig,'Tag','meshsize');
    set(the_handle,'Enable','on');

%% Only enable this if in psa mode (i.e. not for ARPACK mode, 
%% sparse matrices or Hessenberg (rect))
    if projection_on==1,
      the_handle = findobj(fig,'Tag','Safety');
      set(the_handle,'Enable','on');
      the_handle = findobj(fig,'Tag','ExportSchur');
      set(the_handle,'Enable','on');
    end;

    if ~isempty(ps_data.ews),
      the_handle = findobj(fig,'Tag','ExportEws');
      set(the_handle,'Enable','on');
    end;

%% Enable the buttons

    the_handle = findobj(fig,'Tag','Plot3D');
    set(the_handle,'Enable','on');

%% Only enable the Eig Cond No. & Pseudomode buttons if there are eigenvalues
%% and the matrix is square, or generated from Arnoldi factorisation
    if enable_psmode,
      the_handle = findobj(fig,'Tag','PseudoMode');
      set(the_handle,'Enable','on');
    end;

% Enable the Go! button according to the stored state
    the_handle = findobj(fig,'Tag','RedrawPlot');
    set(the_handle,'Enable',ps_data.go_btn_state);

    the_handle = findobj(fig,'Tag','OrigPlot');
    set(the_handle,'Enable','on');
    the_handle = findobj(fig,'Tag','Print');
    set(the_handle,'Enable','on');

    the_handle = findobj(fig,'Tag','AutoLev');
    set(the_handle,'Enable','on');

    the_handle = findobj(fig,'Tag','firstlev');
    set(the_handle,'Enable','on');
    the_handle = findobj(fig,'Tag','lastlev');
    set(the_handle,'Enable','on');
    the_handle = findobj(fig,'Tag','nolev');
    set(the_handle,'Enable','on');

% Enable click/drag in axes again
    if isfield(ps_data,'zoom_list'),
      if isfield(ps_data.zoom_list{ps_data.zoom_pos},'Z') ... 
         & ~isempty(ps_data.zoom_list{ps_data.zoom_pos}.Z),
        set(fig,'WindowButtonDownFcn','eigtool_switch_fn(''PsArea'');');
      end;
    end;

  end;
end;

function set_menu_itms(fig,state)

    the_handle = findobj(fig,'Tag','Export');
    set(the_handle,'Enable',state);
    the_handle = findobj(fig,'Tag','FilePrint');
    set(the_handle,'Enable',state);
    the_handle = findobj(fig,'Tag','CreateCode');
    set(the_handle,'Enable',state);
    the_handle = findobj(fig,'Tag','PrintOnly');
    set(the_handle,'Enable',state);
    the_handle = findobj(fig,'Tag','Safety');
    set(the_handle,'Enable',state);
    the_handle = findobj(fig,'Tag','UnequalLevels');
    set(the_handle,'Enable',state);


function set_numbersmenu_itms(fig,ps_data)

% What type of matrix do we have?
    if issparse(ps_data.input_matrix),
      type = 's';
    else
      type = 'd';
    end;

    [m,n] = size(ps_data.input_matrix);
    if m==n,
      shape = 's';
    else
      shape = 'r';
    end;

    h = findobj(fig,'Tag','NumbersMenu');
    itms = get(h,'children');

% Enable each menu item accordingly
    for i=1:length(itms),
      routine_data = get(itms(i),'userdata');
      if (routine_data.mtx_type=='b' | routine_data.mtx_type==type) ...
       & (routine_data.mtx_shape=='b' | routine_data.mtx_shape==shape),
         set(itms(i),'Enable','on');
      else
         set(itms(i),'Enable','off');
      end;
    end;


