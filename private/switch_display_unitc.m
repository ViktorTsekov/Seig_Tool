function ps_data = switch_display_unitc(fig,cax,this_ver,ps_data)

% function ps_data = switch_display_unitc(fig,cax,this_ver,ps_data)
%
% Function called when the 'Display Unit Circle' menu option is
% chosen.
%
% This is an unmodified original Eigtool function included in Structured Eigtool.


% Version 2.1 (Mon Mar 16 00:24:50 CDT 2009)
% Copyright 2002 - 2009 by Tom Wright; maintained by Mark Embree (embree@rice.edu)

      mnu_itm_h = findobj(fig,'Tag','DisplayUnitC');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'off'),
        set(mnu_itm_h,'checked','on');
      else
        set(mnu_itm_h,'checked','off');
      end;
      ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
