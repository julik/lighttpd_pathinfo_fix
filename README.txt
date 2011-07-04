= lighttpd_pathinfo_fix

* http://github.com/julik/lighttpd_pathinfo_fix

== DESCRIPTION:

This middleware fixes the lighttpd PATH_INFO for apps mounted at / in a way that is compatible with everything.
That is, in contrast with the Rack documentation this middleware actually fucking works.

== FEATURES/PROBLEMS:

Resets script path variables in the Rack request environment. No side effects now. Will also not intervene
if the server is not lighttpd.

== SYNOPSIS:

    # In your rackup file or in your Sinatra app
    use LighttpdPathinfoFix

== REQUIREMENTS:

	Ruby > 1.8.5

== INSTALL:

    gem install lighttpd_pathinfo_fix

== LICENSE:

(The MIT License)

Copyright (c) 2011 Julik Tarkhanov

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
