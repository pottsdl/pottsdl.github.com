" HTML.vim - Macros, menus, and autocommands for html mode
"
" OVERVIEW
"	This file has three parts:
"		SECTION 1: Setup of menus and associated macros
"		SECTION 2: Setup of macros unassociated with menus
"		SECTION 3: Additional autocommands
"
"	My main interest here was creating some syntax specific menus (starting 
"	with HTML) for gvim.  Besides helping the novice, the menus are a quick 
"	way to view what some of the macros are assigned to.  Macros and keyboard
"	mappings are only active in buffers editing HTML files.  Two main menus
"	are created - one for HTML tags (with submenus), and another for tools.
"	The tools menu can be configured to call some validations tools, for
"	example - TODO.
"
"	Originally, I was using Alt-Key sequences for my bindings (e.g. <M-c>
"	was bound to the insert comment macro).  I quickly ran out of letters,
"	so I think the ;xx plan works better.
"
"	I also fully specified mappings and menus for each of the 4 modes:
"	normal, visual, insert, and command.  This might be overkill, but I
"	found it useful to have minor differences in each of the macros.  The
"	utility of command mode mappings is particularly questionalble.
"
"	I also added an autocommand to read a user's HTML template file when
"	editing a nonexistant html file.  Also, when writing the buffer, a
"	BufWritePost autocommand calls an open netscape to view the results.  
"	See notes on this below.
"
" BUGS, SUGGESTIONS, and COPYRIGHT
"
"       These macros may be freely copied and modified.  If you find bugs, or
"	if have some suggestions, or if you find them useful, I'd appreciate 
"	hearing about it.
"
"       T Scott Urban
"       urban@unix.mauigateway.com
"
" CREDITS
" 	I took a lot of these macros from Doug _____ (drenze@avalon.net).  
"	I found his work at http://www.grafnetix.com/~laurent/vim/html.mac 
"	with some modifications by Ives Aerts (ives@sonytel.be).
"
"
"
"
" SECTION 1: Setup menus and associated mapped keyboard shortcuts
"
"" Menu HTML Tags
"
""" Comment:
"	normal		new comment on previous line
"	visual		wrap visual selection in comment
"	insert		insert comment at cursor position
if has("gui")
  nmenu HTML\ Tags.Comment\ \ \ \ \ ;cm O<!-- COMMENT --><Esc>2bcw
  vmenu HTML\ Tags.Comment\ \ \ \ \ ;cm <Esc>`>a --><Esc>`<i<!-- <Esc>
  imenu HTML\ Tags.Comment\ \ \ \ \ ;cm <!-- COMMENT --><Esc>2bcw
endif
nmap	;cm	O<!-- COMMENT --><Esc>bbcw
vmap	;cm	<Esc>`>a --><Esc>`<i<!-- <Esc>
imap	;cm	<!-- COMMENT --><Esc>2bcw
"
""" Name Anchor:
"	normal		creates name anchor on previous line
"	visual		wrap name anchor around current visual selection
"	insert		insert name anchor at cursor position
if has("gui")
  nmenu HTML\ Tags.Name\ Anchor\ ;an O<a name="NAME"><Esc>2bcw
  vmenu HTML\ Tags.Name\ Anchor\ ;an <Esc>`>a"><Esc>`<i<a name="<Esc>l
  imenu HTML\ Tags.Name\ Anchor\ ;an <a name="NAME"><Esc>2bcw
endif
nmap	;an	O<a name="NAME"><Esc>2bcw
vmap	;an	<Esc>`>a"><Esc>`<i<a name="<Esc>l
imap	;an	<a name="NAME"><Esc>2bcw
"
""" Href Anchor:
"	normal		creates href anchor on previous line
"	visual		wraps href anchor around current visual selection
"	insert		inserts href anchor at cursor position
if has("gui")
  nmenu HTML\ Tags.Href\ Anchor\ ;ah O<a href="URL">TAG</a><Esc>5bcw
  vmenu HTML\ Tags.Href\ Anchor\ ;ah <Esc>`>a</a><Esc>`<i<a href="URL"><Esc>2bcw
  imenu HTML\ Tags.Href\ Anchor\ ;ah <a href="URL">TAG</a><Esc>5bcw
endif
nmap	;ah	O<a href="URL">TAG</a><Esc>5bcw
vmap	;ah	<Esc>`>a</a><Esc>`<i<a href="URL"><Esc>2bcw
imap	;ah	<a href="URL">TAG</a><Esc>5bcw
"
""" Image:
"	normal		creates image on previous line
"	visual		creates image around current visual selection ??
"	insert		inserts image at cursor position
"
" if you don't like the alt tag, remove it.  Just trying to 
" enforce good style ;>
if has("gui")
  nmenu HTML\ Tags.Image\ \ \ \ \ \ \ ;im O<img src="URL" alt="IMAGE"><Esc>6bcw
  vmenu HTML\ Tags.Image\ \ \ \ \ \ \ ;im <Esc>`>a" alt="IMAGE"><Esc>`<i<img src="><Esc>l
  imenu HTML\ Tags.Image\ \ \ \ \ \ \ ;im <img src="URL" alt="IMAGE"><Esc>6bcw
endif
nmap	;im	O<img src="URL" alt="IMAGE"><Esc>6bcw
vmap	;im	<Esc>`>a" alt="IMAGE"><Esc>`<i<img src="<Esc>l
imap	;im	<img src="URL" alt="IMAGE"><Esc>6bcw
"
""" Break:
"	normal		creates break on previous line
"	visual		creates break before selection
"	insert		inserts break at cursor
if has("gui")
  nmenu HTML\ Tags.Break\ \ \ \ \ \ \ ;br	O<br><Esc>
  vmenu HTML\ Tags.Break\ \ \ \ \ \ \ ;br	<Esc>`<i<br><Esc>
  imenu HTML\ Tags.Break\ \ \ \ \ \ \ ;br	<br>
endif
nmap	;br	O<br><Esc>
vmap	;br	<Esc>`<i<br><Esc>
imap	;br	<br>
"
""" Horizontal Rule:
"	normal		creates rule on previous line
"	visual		inserts rule before selection
"	insert		inserts rule at cursor
if has("gui")
  nmenu HTML\ Tags.Rule\ \ \ \ \ \ \ \ ;hr	O<hr><Esc>
  vmenu HTML\ Tags.Rule\ \ \ \ \ \ \ \ ;hr	<Esc>`<i<hr><CR><Esc>
  imenu HTML\ Tags.Rule\ \ \ \ \ \ \ \ ;hr	<hr><CR>
endif
nmap	;hr	O<hr><CR><Esc>
vmap	;hr	<Esc>`<i<hr><cr><Esc>
imap	;hr	<hr><CR>
"
""" Headings Sub-Menu
"	normal		creates selected heading on previous line
"	visual		creates selected heading around visual selection
"	insert		inserts selected heading at cursor position
"
"""" H1 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H1\ \ ;h1	O<h1>HEADING</h1><Esc>3bcw
  vmenu HTML\ Tags.Headings.H1\ \ ;h1	<Esc>`>a</h1><Esc>`<i<h1><Esc>l
  imenu HTML\ Tags.Headings.H1\ \ ;h1	<h1>HEADING</h1><Esc>3bcw
endif
nmap	;h1	O<h1>HEADING</h1><Esc>3bcw
vmap	;h1	<Esc>`>a</h1><Esc>`<i<h1><Esc>l
imap	;h1	<h1>HEADING</h1><Esc>3bcw
"
"""" H2 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H2\ \ ;h2	O<h2>HEADING</h2><Esc>3bcw
  vmenu HTML\ Tags.Headings.H2\ \ ;h2	<Esc>`>a</h2><Esc>`<i<h2><Esc>l
  imenu HTML\ Tags.Headings.H2\ \ ;h2	<h2>HEADING</h2><Esc>3bcw
endif
nmap	;h2	O<h2>HEADING</h2><Esc>3bcw
vmap	;h2	<Esc>`>a</h2><Esc>`<i<h2><Esc>l
imap	;h2	<h2>HEADING</h2><Esc>3bcw
"
"""" H3 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H3\ \ ;h3	O<h3>HEADING</h3><Esc>3bcw
  vmenu HTML\ Tags.Headings.H3\ \ ;h3	<Esc>`>a</h3><Esc>`<i<h3><Esc>l
  imenu HTML\ Tags.Headings.H3\ \ ;h3	<h3>HEADING</h3><Esc>3bcw
endif
nmap	;h3	O<h3>HEADING</h3><Esc>3bcw
vmap	;h3	<Esc>`>a</h3><Esc>`<i<h3><Esc>l
imap	;h3	<h3>HEADING</h3><Esc>3bcw
"
"""" H4 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H4\ \ ;h4	O<h4>HEADING</h4><Esc>3bcw
  vmenu HTML\ Tags.Headings.H4\ \ ;h4	<Esc>`>a</h4><Esc>`<i<h4><Esc>l
  imenu HTML\ Tags.Headings.H4\ \ ;h4	<h4>HEADING</h4><Esc>3bcw
endif
nmap	;h4	O<h4>HEADING</h4><Esc>3bcw
vmap	;h4	<Esc>`>a</h4><Esc>`<i<h4><Esc>l
imap	;h4	<h4>HEADING</h4><Esc>3bcw
"
"""" H5 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H5\ \ ;h5	O<h5>HEADING</h5><Esc>3bcw
  vmenu HTML\ Tags.Headings.H5\ \ ;h5	<Esc>`>a</h5><Esc>`<i<h5><Esc>l
  imenu HTML\ Tags.Headings.H5\ \ ;h5	<h5>HEADING</h5><Esc>3bcw
endif
nmap	;h5	O<h5>HEADING</h5><Esc>3bcw
vmap	;h5	<Esc>`>a</h5><Esc>`<i<h5><Esc>l
imap	;h5	<h5>HEADING</h5><Esc>3bcw
"
"""" H6 Heading
if has("gui")
  nmenu HTML\ Tags.Headings.H6\ \ ;h6	O<h6>HEADING</h6><Esc>3bcw
  vmenu HTML\ Tags.Headings.H6\ \ ;h6	<Esc>`>a</h6><Esc>`<i<h6><Esc>l
  imenu HTML\ Tags.Headings.H6\ \ ;h6	<h6>HEADING</h6><Esc>3bcw
endif
nmap	;h6	O<h6>HEADING</h6><Esc>3bcw
vmap	;h6	<Esc>`>a</h6><Esc>`<i<h6><Esc>l
imap	;h6	<h6>HEADING</h6><Esc>3bcw
"
""" Format:
"	normal		creates selected format on previous line
"	visual		creates selected format around visual selection
"	insert		creates selected format at cursor position
"
" Address format
if has("gui")
  nmenu HTML\ Tags.Formats.Address\ \ \ \ \ ;ad	O<address>TEXT</address><Esc>3bcw
  vmenu HTML\ Tags.Formats.Address\ \ \ \ \ ;ad	<Esc>`>a</address><Esc>`<i<address><Esc>l
  imenu HTML\ Tags.Formats.Address\ \ \ \ \ ;ad	<address>TEXT</address><Esc>3bcw
endif
nmap	;ad	O<address>TEXT</address><Esc>3bcw
vmap	;ad	<Esc>`>a</address><Esc>`<i<address><Esc>l
imap	;ad	<address>TEXT</address><Esc>3bcw
"
" Bold format
if has("gui")
  nmenu HTML\ Tags.Formats.Bold\ \ \ \ \ \ \ \ ;bo	O<b>TEXT</b><Esc>3bcw
  vmenu HTML\ Tags.Formats.Bold\ \ \ \ \ \ \ \ ;bo	<Esc>`>a</b><Esc>`<i<b><Esc>l
  imenu HTML\ Tags.Formats.Bold\ \ \ \ \ \ \ \ ;bo	<b>TEXT</b><Esc>3bcw
endif
nmap	;bo	O<b>TEXT</b><Esc>3bcw
vmap	;bo	<Esc>`>a</b><Esc>`<i<b><Esc>l
imap	;bo	<b>TEXT</b><Esc>3bcw
"
" Big format
if has("gui")
  nmenu HTML\ Tags.Formats.Bigger\ \ \ \ \ \ ;bi	O<big>TEXT</big><Esc>3bcw
  vmenu HTML\ Tags.Formats.Bigger\ \ \ \ \ \ ;bi	<Esc>`>a</big><Esc>`<i<big><Esc>l
  imenu HTML\ Tags.Formats.Bigger\ \ \ \ \ \ ;bi	<big>TEXT</big><Esc>3bcw
endif
nmap	;bi	O<big>TEXT</big><Esc>3bcw
vmap	;bi	<Esc>`>a</big><Esc>`<i<big><Esc>l
imap	;bi	<big>TEXT</big><Esc>3bcw
"
" Blink format - you might take this out to discourage use
if has("gui")
  nmenu HTML\ Tags.Formats.Blink\ \ \ \ \ \ \ ;bk	O<blink>TEXT</blink><Esc>3bcw
  vmenu HTML\ Tags.Formats.Blink\ \ \ \ \ \ \ ;bk	<Esc>`>a</blink><Esc>`<i<blink><Esc>l
  imenu HTML\ Tags.Formats.Blink\ \ \ \ \ \ \ ;bk	<blink>TEXT</blink><Esc>3bcw
endif
nmap	;bk	O<blink>TEXT</blink><Esc>3bcw
vmap	;bk	<Esc>`>a</blink><Esc>`<i<blink><Esc>l
imap	;bk	<blink>TEXT</blink><Esc>3bcw
"
" Blockquote format
if has("gui")
  nmenu HTML\ Tags.Formats.Blockquote\ \ ;bl	O<blockquote>TEXT</blockquote><Esc>3bcw
  vmenu HTML\ Tags.Formats.Blockquote\ \ ;bl	<Esc>`>a</blockquote><Esc>`<i<blockquote><Esc>l
  imenu HTML\ Tags.Formats.Blockquote\ \ ;bl	<blockquote>TEXT</blockquote><Esc>3bcw
endif
nmap	;bl	O<blockquote>TEXT</blockquote><Esc>3bcw
vmap	;bl	<Esc>`>a</blockquote><Esc>`<i<blockquote><Esc>l
imap	;bl	<blockquote>TEXT</blockquote><Esc>3bcw
"
" Center format
if has("gui")
  nmenu HTML\ Tags.Formats.Center\ \ \ \ \ \ ;ce	O<center>TEXT</center><Esc>3bcw
  vmenu HTML\ Tags.Formats.Center\ \ \ \ \ \ ;ce	<Esc>`>a</center><Esc>`<i<center><Esc>l
  imenu HTML\ Tags.Formats.Center\ \ \ \ \ \ ;ce	<center>TEXT</center><Esc>3bcw
endif
nmap	;ce	O<center>TEXT</center><Esc>3bcw
vmap	;ce	<Esc>`>a</center><Esc>`<i<center><Esc>l
imap	;ce	<center>TEXT</center><Esc>3bcw
"
" Cite format
if has("gui")
  nmenu HTML\ Tags.Formats.Cite\ \ \ \ \ \ \ \ ;ci	O<cite>TEXT</cite><Esc>3bcw
  vmenu HTML\ Tags.Formats.Cite\ \ \ \ \ \ \ \ ;ci	<Esc>`>a</cite><Esc>`<i<cite><Esc>l
  imenu HTML\ Tags.Formats.Cite\ \ \ \ \ \ \ \ ;ci	<cite>TEXT</cite><Esc>3bcw
endif
nmap	;ci	O<cite>TEXT</cite><Esc>3bcw
vmap	;ci	<Esc>`>a</cite><Esc>`<i<cite><Esc>l
imap	;ci	<cite>TEXT</cite><Esc>3bcw
"
" Code format
if has("gui")
  nmenu HTML\ Tags.Formats.Code\ \ \ \ \ \ \ \ ;co	O<code>TEXT</code><Esc>3bcw
  vmenu HTML\ Tags.Formats.Code\ \ \ \ \ \ \ \ ;co	<Esc>`>a</code><Esc>`<i<code><Esc>l
  imenu HTML\ Tags.Formats.Code\ \ \ \ \ \ \ \ ;co	<code>TEXT</code><Esc>3bcw
endif
nmap	;co	O<code>TEXT</code><Esc>3bcw
vmap	;co	<Esc>`>a</code><Esc>`<i<code><Esc>l
imap	;co	<code>TEXT</code><Esc>3bcw
"
" Definition format
if has("gui")
  nmenu HTML\ Tags.Formats.Definition\ \ ;df	O<dfn>TEXT</dfn><Esc>3bcw
  vmenu HTML\ Tags.Formats.Definition\ \ ;df	<Esc>`>a</dfn><Esc>`<i<dfn><Esc>l
  imenu HTML\ Tags.Formats.Definition\ \ ;df	<dfn>TEXT</dfn><Esc>3bcw
endif
nmap	;df	O<dfn>TEXT</dfn><Esc>3bcw
vmap	;df	<Esc>`>a</dfn><Esc>`<i<dfn><Esc>l
imap	;df	<dfn>TEXT</dfn><Esc>3bcw
"
" Emphasis format
if has("gui")
  nmenu HTML\ Tags.Formats.Emphasis\ \ \ \ ;em	O<em>TEXT</em><Esc>3bcw
  vmenu HTML\ Tags.Formats.Emphasis\ \ \ \ ;em	<Esc>`>a</em><Esc>`<i<em><Esc>l
  imenu HTML\ Tags.Formats.Emphasis\ \ \ \ ;em	<em>TEXT</em><Esc>3bcw
endif
nmap	;em	O<em>TEXT</em><Esc>3bcw
vmap	;em	<Esc>`>a</em><Esc>`<i<em><Esc>l
imap	;em	<em>TEXT</em><Esc>3bcw
"
" Italics format
if has("gui")
  nmenu HTML\ Tags.Formats.Italics\ \ \ \ \ ;it	O<i>TEXT</i><Esc>3bcw
  vmenu HTML\ Tags.Formats.Italics\ \ \ \ \ ;it	<Esc>`>a</i><Esc>`<i<i><Esc>l
  imenu HTML\ Tags.Formats.Italics\ \ \ \ \ ;it	<i>TEXT</i><Esc>3bcw
endif
nmap	;it	O<i>TEXT</i><Esc>3bcw
vmap	;it	<Esc>`>a</i><Esc>`<i<i><Esc>l
imap	;it	<i>TEXT</i><Esc>3bcw
"
" Keyboard format
if has("gui")
  nmenu HTML\ Tags.Formats.Keyboard\ \ \ \ ;kb	O<kbd>TEXT</kbd><Esc>3bcw
  vmenu HTML\ Tags.Formats.Keyboard\ \ \ \ ;kb	<Esc>`>a</kbd><Esc>`<i<kbd><Esc>l
  imenu HTML\ Tags.Formats.Keyboard\ \ \ \ ;kb	<kbd>TEXT</kbd><Esc>3bcw
endif
nmap	;kb	O<kbd>TEXT</kbd><Esc>3bcw
vmap	;kb	<Esc>`>a</kbd><Esc>`<i<kbd><Esc>l
imap	;kb	<kbd>TEXT</kbd><Esc>3bcw
"
" No break format
if has("gui")
  nmenu HTML\ Tags.Formats.No\ Break\ \ \ \ ;nb	O<nobr>TEXT</nobr><Esc>3bcw
  vmenu HTML\ Tags.Formats.No\ Break\ \ \ \ ;nb	<Esc>`>a</nobr><Esc>`<i<nobr><Esc>l
  imenu HTML\ Tags.Formats.No\ Break\ \ \ \ ;nb	<nobr>TEXT</nobr><Esc>3bcw
endif
nmap	;nb	O<nobr>TEXT</nobr><Esc>3bcw
vmap	;nb	<Esc>`>a</nobr><Esc>`<i<nobr><Esc>l
imap	;nb	<nobr>TEXT</nobr><Esc>3bcw
"
" Pre format
if has("gui")
  nmenu HTML\ Tags.Formats.Preformat\ \ \ ;pr	O<pre>TEXT</pre><Esc>3bcw
  vmenu HTML\ Tags.Formats.Preformat\ \ \ ;pr	<Esc>`>a</pre><Esc>`<i<pre><Esc>l
  imenu HTML\ Tags.Formats.Preformat\ \ \ ;pr	<pre>TEXT</pre><Esc>3bcw
endif
nmap	;pr	O<pre>TEXT</pre><Esc>3bcw
vmap	;pr	<Esc>`>a</pre><Esc>`<i<pre><Esc>l
imap	;pr	<pre>TEXT</pre><Esc>3bcw
"
" Strike format
if has("gui")
  nmenu HTML\ Tags.Formats.Strike\ \ \ \ \ \ ;sk	O<strike>TEXT</strike><Esc>3bcw
  vmenu HTML\ Tags.Formats.Strike\ \ \ \ \ \ ;sk	<Esc>`>a</strike><Esc>`<i<strike><Esc>l
  imenu HTML\ Tags.Formats.Strike\ \ \ \ \ \ ;sk	<strike>TEXT</strike><Esc>3bcw
endif
nmap	;sk	O<strike>TEXT</strike><Esc>3bcw
vmap	;sk	<Esc>`>a</strike><Esc>`<i<strike><Esc>l
imap	;sk	<strike>TEXT</strike><Esc>3bcw
"
" Sample format
if has("gui")
  nmenu HTML\ Tags.Formats.Sample\ \ \ \ \ \ ;sa	O<samp>TEXT</samp><Esc>3bcw
  vmenu HTML\ Tags.Formats.Sample\ \ \ \ \ \ ;sa	<Esc>`>a</samp><Esc>`<i<samp><Esc>l
  imenu HTML\ Tags.Formats.Sample\ \ \ \ \ \ ;sa	<samp>TEXT</samp><Esc>3bcw
endif
nmap	;sa	O<samp>TEXT</samp><Esc>3bcw
vmap	;sa	<Esc>`>a</samp><Esc>`<i<samp><Esc>l
imap	;sa	<samp>TEXT</samp><Esc>3bcw
"
" Small format
if has("gui")
  nmenu HTML\ Tags.Formats.Smaller\ \ \ \ \ ;sm	O<small>TEXT</small><Esc>3bcw
  vmenu HTML\ Tags.Formats.Smaller\ \ \ \ \ ;sm	<Esc>`>a</small><Esc>`<i<small><Esc>l
  imenu HTML\ Tags.Formats.Smaller\ \ \ \ \ ;sm	<small>TEXT</small><Esc>3bcw
endif
nmap	;sm	O<small>TEXT</small><Esc>3bcw
vmap	;sm	<Esc>`>a</small><Esc>`<i<small><Esc>l
imap	;sm	<small>TEXT</small><Esc>3bcw
"
" Strong format
if has("gui")
  nmenu HTML\ Tags.Formats.Strong\ \ \ \ \ \ ;st	O<strong>TEXT</strong><Esc>3bcw
  vmenu HTML\ Tags.Formats.Strong\ \ \ \ \ \ ;st	<Esc>`>a</strong><Esc>`<i<strong><Esc>l
  imenu HTML\ Tags.Formats.Strong\ \ \ \ \ \ ;st	<strong>TEXT</strong><Esc>3bcw
endif
nmap	;st	O<strong>TEXT</strong><Esc>3bcw
vmap	;st	<Esc>`>a</strong><Esc>`<i<strong><Esc>l
imap	;st	<strong>TEXT</strong><Esc>3bcw
"
" Subscript format
if has("gui")
  nmenu HTML\ Tags.Formats.Subscript\ \ \ ;sb	O<sub>TEXT</sub><Esc>3bcw
  vmenu HTML\ Tags.Formats.Subscript\ \ \ ;sb	<Esc>`>a</sub><Esc>`<i<sub><Esc>l
  imenu HTML\ Tags.Formats.Subscript\ \ \ ;sb	<sub>TEXT</sub><Esc>3bcw
endif
nmap	;sb	O<sub>TEXT</sub><Esc>3bcw
vmap	;sb	<Esc>`>a</sub><Esc>`<i<sub><Esc>l
imap	;sb	<sub>TEXT</sub><Esc>3bcw
"
" Superscript format
if has("gui")
  nmenu HTML\ Tags.Formats.Superscript\ ;sp	O<sup>TEXT</sup><Esc>3bcw
  vmenu HTML\ Tags.Formats.Superscript\ ;sp	<Esc>`>a</sup><Esc>`<i<sup><Esc>l
  imenu HTML\ Tags.Formats.Superscript\ ;sp	<sup>TEXT</sup><Esc>3bcw
endif
nmap	;sp	O<sup>TEXT</sup><Esc>3bcw
vmap	;sp	<Esc>`>a</sup><Esc>`<i<sup><Esc>l
imap	;sp	<sup>TEXT</sup><Esc>3bcw
"
" Typewriter heading
if has("gui")
  nmenu HTML\ Tags.Formats.Typerwriter\ ;tt	O<tt>TEXT</tt><Esc>3bcw
  vmenu HTML\ Tags.Formats.Typerwriter\ ;tt	<Esc>`>a</tt><Esc>`<i<tt><Esc>l
  imenu HTML\ Tags.Formats.Typerwriter\ ;tt	<tt>TEXT</tt><Esc>3bcw
endif
nmap	;tt	O<tt>TEXT</tt><Esc>3bcw
vmap	;tt	<Esc>`>a</tt><Esc>`<i<tt><Esc>l
imap	;tt	<tt>TEXT</tt><Esc>3bcw
"
" Underline heading
if has("gui")
  nmenu HTML\ Tags.Formats.Underline\ \ \ ;uu	O<u>TEXT</u><Esc>3bcw
  vmenu HTML\ Tags.Formats.Underline\ \ \ ;uu	<Esc>`>a</u><Esc>`<i<u><Esc>l
  imenu HTML\ Tags.Formats.Underline\ \ \ ;uu	<u>TEXT</u><Esc>3bcw
endif
nmap	;uu	O<u>TEXT</u><Esc>3bcw
vmap	;uu	<Esc>`>a</u><Esc>`<i<u><Esc>l
imap	;uu	<u>TEXT</u><Esc>3bcw
"
" Variable format
if has("gui")
  nmenu HTML\ Tags.Formats.Variable\ \ \ \ ;vv	O<var>TEXT</var><Esc>3bcw
  vmenu HTML\ Tags.Formats.Variable\ \ \ \ ;vv	<Esc>`>a</var><Esc>`<i<var><Esc>l
  imenu HTML\ Tags.Formats.Variable\ \ \ \ ;vv	<var>TEXT</var><Esc>3bcw
endif
nmap	;vv	O<var>TEXT</var><Esc>3bcw
vmap	;vv	<Esc>`>a</var><Esc>`<i<var><Esc>l
imap	;vv	<var>TEXT</var><Esc>3bcw
"
""" List Sub-Menu
"	normal		creates selected item on previous line
"	visual		creates selected item around visual selection
"	insert		creates selected item at cursor position
"
"	for multi-line visual selections with ;ul, ;ol, etc. inserts
"	<li> at beginning of selection and at beginning of each line
"	in selection and puts whole thing in list (<ul></ul>, e.g)
" 	- kind of a kludge right now, but it works
"
"""" list Item -
if has("gui")
  nmenu HTML\ Tags.List.List\ Item\ \ \ \ \ \ \ ;li	O<li>LIST ITEM<Esc>2b2cw
  vmenu HTML\ Tags.List.List\ Item\ \ \ \ \ \ \ ;li	<Esc>`<i<li><Esc>
  imenu HTML\ Tags.List.List\ Item\ \ \ \ \ \ \ ;li	<li>LIST ITEM<Esc>2b2cw
endif
nmap	;li	O<li>LIST ITEM<Esc>2b2cw
vmap	;li	<Esc>`<i<li><Esc>
imap	;li	<li>LIST ITEM<Esc>2b2cw
"
"""" list Header
if has("gui")
  nmenu HTML\ Tags.List.List\ Header\ \ \ \ \ ;lh	O<lh>LIST HEADER</lh><Esc>4b2cw
  vmenu HTML\ Tags.List.List\ Header\ \ \ \ \ ;lh	<Esc>`>a</lh><Esc>`<i<lh><Esc>l
  imenu HTML\ Tags.List.List\ Header\ \ \ \ \ ;lh	<lh>LIST HEADER</lh><Esc>4b2cw
endif
nmap	;lh	O<lh>LIST HEADER</lh><Esc>4b2cw
vmap	;lh	<Esc>`>a</lh><Esc>`<i<lh><Esc>l
imap	;lh	<lh>LIST HEADER</lh><Esc>4b2cw
"
"""" Unordered List
if has("gui")
  nmenu HTML\ Tags.List.Unordered\ List\ \ ;ul	O<ul><CR>  <li>LIST ITEM<CR><BS><BS></ul><Esc>4b2cw
  vmenu HTML\ Tags.List.Unordered\ List\ \ ;ul	<Esc>`>a<CR></ul><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<ul><CR>    <li><Esc>/<li><.ul><CR>4x4X
  imenu HTML\ Tags.List.Unordered\ List\ \ ;ul	<CR><ul><CR>  <li>LIST ITEM<CR><BS><BS></ul><Esc>4b2cw
endif
nmap	;ul	O<ul><CR>  <li>LIST ITEM<CR><BS><BS></ul><Esc>4b2cw
vmap	;ul	<Esc>`>a<CR></ul><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<ul><CR>    <li><Esc>/<li><.ul><CR>4x4X
imap	;ul	<CR><ul><CR>  <li>LIST ITEM<CR><BS><BS></ul><Esc>4b2cw
"
"""" Ordered List
if has("gui")
  nmenu HTML\ Tags.List.Ordered\ List\ \ \ \ ;ol	O<ol><CR>  <li>LIST ITEM<CR><BS><BS></ol><Esc>4b2cw
  vmenu HTML\ Tags.List.Ordered\ List\ \ \ \ ;ol	<Esc>`>a<CR></ol><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<ol><CR>    <li><Esc>/<li><.ol><CR>4x4X
  imenu HTML\ Tags.List.Ordered\ List\ \ \ \ ;ol	<CR><ol><CR>  <li>LIST ITEM<CR><BS><BS></ol><Esc>4b2cw
endif
nmap	;ol	O<ol><CR>  <li>LIST ITEM<CR><BS><BS></ol><Esc>4b2cw
vmap	;ol	<Esc>`>a<CR></ol><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<ol><CR>    <li><Esc>/<li><.ol><CR>4x4X
imap	;ol	<CR><ol><CR>  <li>LIST ITEM<CR><BS><BS></ol><Esc>4b2cw
"
"""" Directory List
if has("gui")
  nmenu HTML\ Tags.List.Directory\ List\ \ ;di	O<dir><CR>  <li>LIST ITEM<CR><BS><BS></dir><Esc>4b2cw
  vmenu HTML\ Tags.List.Directory\ List\ \ ;di	<Esc>`>a<CR></dir><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<dir><CR>    <li><Esc>/<li><.dir><CR>4x4X
  imenu HTML\ Tags.List.Directory\ List\ \ ;di	<CR><dir><CR>  <li>LIST ITEM<CR><BS><BS></dir><Esc>4b2cw
endif
nmap	;di	O<dir><CR>  <li>LIST ITEM<CR><BS><BS></dir><Esc>4b2cw
vmap	;di	<Esc>`>a<CR></dir><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<dir><CR>    <li><Esc>/<li><.dir><CR>4x4X
imap	;di	<CR><dir><CR>  <li>LIST ITEM<CR><BS><BS></dir><Esc>4b2cw
"
"""" Menu List
if has("gui")
  nmenu HTML\ Tags.List.Menu\ List\ \ \ \ \ \ \ ;mu	O<mu><CR>  <li>LIST ITEM<CR><BS><BS></mu><Esc>4b2cw
  vmenu HTML\ Tags.List.Menu\ List\ \ \ \ \ \ \ ;mu	<Esc>`>a<CR></mu><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<mu><CR>    <li><Esc>/<li><.mu><CR>4x4X
  imenu HTML\ Tags.List.Menu\ List\ \ \ \ \ \ \ ;mu	<CR><mu><CR>  <li>LIST ITEM<CR><BS><BS></mu><Esc>4b2cw
endif
nmap	;mu	O<mu><CR>  <li>LIST ITEM<CR><BS><BS></mu><Esc>4b2cw
vmap	;mu	<Esc>`>a<CR></mu><Esc>:'<+1,'>+1s/^/    <li>/<CR>`<i<mu><CR>    <li><Esc>/<li><.mu><CR>4x4X
imap	;mu	<CR><mu><CR>  <li>LIST ITEM<CR><BS><BS></mu><Esc>4b2cw
"
"""" Definition Item
"	dt an dd are the same menu item - though dd can be called via the ;dd macro 
"	below.  this assumes you will always want a dd with every dd.
if has("gui")
  nmenu HTML\ Tags.List.Definition\ \ \ \ \ \ ;dt	O<dt>TERM<CR><dd>DEFINITION<Esc>5bcw
  vmenu HTML\ Tags.List.Definition\ \ \ \ \ \ ;dt	<Esc>`>a<CR><dd>DEFINITION <Esc>`<i<dt><Esc>5wcw
  imenu HTML\ Tags.List.Definition\ \ \ \ \ \ ;dt	<dt>TERM<CR><dd>DEFINITION<Esc>5bcw
endif
nmap	;dt	O<dt>TERM<CR><dd>DEFINITION<Esc>5bcw
vmap	;dt	<Esc>`>a<CR><dd>DEFINITION <Esc>`<i<dt><Esc>5wcw
imap	;dt	<dt>TERM<CR><dd>DEFINITION<Esc>5bcw
"
"""" Definition list
" TODO - set this up so that multi-line visual seleciton get turned into multiple
"	 entries (like ul, ol, etc.)
if has("gui")
  nmenu HTML\ Tags.List.Definition\ List\ ;dl	O<dl><CR>  <li>LIST ITEM<CR><BS><BS></dl><Esc>4b2cw
  vmenu HTML\ Tags.List.Definition\ List\ ;dl	<Esc>`>a<CR>    <dd>DEFINITION<CR><BS><BS><BS><BS></dl><Esc>`<i<dl><CR>    <dt><Esc>l
  imenu HTML\ Tags.List.Definition\ List\ ;dl	<CR><dl><CR>  <li>LIST ITEM<CR><BS><BS></dl><Esc>4b2cw
endif
nmap	;dl	O<dl><CR>  <li>LIST ITEM<CR><BS><BS></dl><Esc>4b2cw
vmap	;dl	<Esc>`>a<CR></dl><Esc>`<i<dl><CR>  <li><Esc>l
imap	;dl	<CR><dl><CR>  <li>LIST ITEM<CR><BS><BS></dl><Esc>4b2cw
"
" TODO - tables submenu, forms submenu
"
"
"
" SECTION 2: macros unassociated with menus
"	In this section - I placed some of the Macros from Doug's file that 
"	I didn't think would be used often enought to justify a menu listing.
"	Actually, I could probably reduce the number in the menus as well.
"	Generally, if an HTML tag is used once in a document (like <html>) then
"	it shouldn't be in a menu.  If you use a template (like the one I
"	call below), then most of those things would be there anyways.  I put
"	a lot of 3.0 tags in this section because they might not be generally
"	supported yet.
"	
"	Haven't set up visual or normal modes for these - still working on the
"	visual v. visual lines problem - prob fixed in VIM5.0g - still TODO
"
" ABBREV (3.0)
map!	;ab	<abbrev></abbrev><Esc>bhhi
" ACRONYM (3.0)
map!	;ac <acronym></acronym><Esc>bhhi
" AU (Author) (3.0)
map!	;au <au></au><eSC>bhhi
" BANNER (3.0)
map!	;ba <banner></banner><Esc>bhhi
" BASE (head)
map!	;bh <base href=""><Esc>hi
" BASEFONT (Netscape)
map!	;bf <basefont size=><eSc>i
" BODY
map!	;bd <body><CR></body><Esc>O
" CAPTION (3.0)
map!	;ca <caption></caption><Esc>bhhi
" CREDIT (3.0)
map!	;cr <credit></credit><Esc>bhhi
" DD (definition for definition list)
map!	;dd <dd></dd><Esc>bhhi
" DEL (deleted text) (3.0)
map!	;de <del></del><Esc>bhhi
" DIV (document division) (3.0)
map!	;dv <div></div><Esc>bhhi
" FIG (figure) (3.0)
map!	;fi <fig src=""></fig><Esc>?"<CR>i
" FN (footnote) (3.0)
map!	;fn <fn></fn><Esc>bhhi
" FONT (Netscape)
map!	;fo <font size=></font><Esc>bhhhi
" HEAD
map!	;he <head><CR></head><Esc>O
" HTML (3.0)
map!	;ht <html><CR></html><Esc>O
" INS (inserted text) (3.0)
map!	;in <ins></ins><Esc>bhhi
" LANG (language context) (3.0)
map!	;la <lang lang=""></lang><Esc>?"<CR>i
" LINK (head)
map!	;lk <link href=""><Esc>hi
" META (head)
map!	;me <meta name="" content=""><Esc>?""<CR>??<CR>a
" NOTE (3.0)
map!	;no <note></note><Esc>bhhi
" OVERLAY (figure overlay image) (3.0)
map!	;ov <overlay src=""><Esc>hi
" P (paragraph)
map!	;pp <p><CR><CR>
" Q (quote) (3.0)
map!	;qu <q></q><Esc>hhhi
" RANGE (3.0) (head)
map!	;ra <range from="" until=""><Esc>Bhi
" STYLE (3.0)
map!	;sn <style notation=""><CR></style><Esc>k/"<CR>a
" TAB (3.0)
map!	;ta <tab>
" TITLE (head)
map!	;ti <title></title><Esc>bhhi
" WBR (word break) (Netscape)
map!	;wb <wbr>
" Special Characters
map!	;& 	&amp;
map!	;cp 	&copy;
map!	;" 	&quot;
map!	;< 	&lt;
map!	;> 	&gt;
"
"
" SECTION 3: Additional Autocommands
"
""" read in skeleton file
":au BufNewFile		*.html	0r 	~/.vim/skeleton.html
""" Change modification data in first 30 lines of file (from vim help)
":au BufWritePre *.html 			ks|1,30g/Last modification: /normal f:lD:read !datekJ's
""" Setup browser to display when writing files
":au BufWritePost *.html !netscape -remote 'openFile(%:p)'
