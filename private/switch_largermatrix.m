function ps_data = switch_largermatrix(fig,cax,this_ver,ps_data)

% function ps_data = switch_largermatrix(fig,cax,this_ver,ps_data)
%
% Function called when the 'Larger matrix' menu option is
% chosen.

% Version 2.1 (Mon Mar 16 00:24:50 CDT 2009)
% Copyright 2002 - 2009 by Tom Wright; maintained by Mark Embree (embree@rice.edu)
%
% This is an unmodified original Eigtool function included in Structured Eigtool.

      mnu_itm_h = findobj(fig,'Tag','LargerMatrix');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'off'),
        set(mnu_itm_h,'checked','on');
      else
        set(mnu_itm_h,'checked','off');
      end;
