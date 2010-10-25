MobileAdsense
=============

A rails plugin to show google adsense for mobile

This plugin is tested with rails 2.3.10.


Usage
-----

In your rails application's template, add the following code. (change client option's value)

    <%= mobile_adsense :client => 'pub-1234567890' %>

And that's it! You can pass any options.

    <%= mobile_adsense :client => 'pub-1234567890', :format => 'mobile_double', :color_border => 'FFFFFF', :color_bg => 'FFFFFF' %>

mobile_adsense helper accesses to the google server to get advertisements. When some error happens while accessing to the google server, mobile_adsense helper returns empty string. (basically, exceptions are **not** raised)


Install
-------

    % script/plugin install git://github.com/milk1000cc/mobile_adsense.git


Author
------

Copyright (c) 2010 milk1000cc, released under the MIT license
