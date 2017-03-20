<!DOCTYPE html>

<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <title>Variables / Learn Vimscript the Hard Way</title>
        <meta name="description" content="">
        <meta name="author" content="Steve Losh">
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <link href="/static/styles/skeleton/base.css" rel="stylesheet" type="text/css" />
        <link href="/static/styles/skeleton/skeleton.css" rel="stylesheet" type="text/css" />
        <link href="/static/styles/skeleton/layout.css" rel="stylesheet" type="text/css" />

        <link href="/static/styles/tango.css" rel="stylesheet" type="text/css" />
        <link href="/static/styles/style.less" rel="stylesheet/less" type="text/css" />

        <script type="text/javascript" src="/static/scripts/less.js"></script>
    </head>

    <body class="">
        <div class="container">
            <header class="sixteen columns">
                <h1><a href="/">Learn Vimscript the Hard Way</a></h1>
            </header>

            
    <section class="nav three columns">
        
<ul>
<li><a href="#variables">Variables</a><ul>
<li><a href="#options-as-variables">Options as Variables</a></li>
<li><a href="#local-options">Local Options</a></li>
<li><a href="#registers-as-variables">Registers as Variables</a></li>
<li><a href="#exercises">Exercises</a></li>
</ul>
</li>
</ul>


        <div class="prevnext">
            
                <a class="prev" href="/chapters/18.html">&laquo; Prev</a>
            
            
                <a class="next" href="/chapters/20.html">Next &raquo;</a>
            
        </div>
    </section>

    <section class="content twelve columns offset-by-one">
        <div> 
<h1 id="variables">Variables</h1>
<p>Up to this point we've covered single commands.  For the next third of the book
we're going to look at Vimscript as a <em>programming language</em>.  This won't be as
instantly gratifying as the rest of what you've learned, but it will lay the
groundwork for the last part of the book, which walks through creating
a full-fledged Vim plugin from scratch.</p>
<p>Let's get started.  The first thing we need to talk about are variables.  Run
the following commands:</p>
<pre class="codehilite"><code class="language-vim">:let foo = "bar"
:echo foo</code></pre>


<p>Vim will display <code>bar</code>.  <code>foo</code> is now a variable, and we've assigned it
a string: <code>"bar"</code>.  Now run these commands:</p>
<pre class="codehilite"><code class="language-vim">:let foo = 42
:echo foo</code></pre>


<p>Vim will display <code>42</code>, because we've reassigned <code>foo</code> to the integer <code>42</code>.</p>
<p>From these short examples it may seem like Vimscript is dynamically typed.
That's not the case, but we'll talk more about that later.</p>
<h2 id="options-as-variables">Options as Variables</h2>
<p>You can read and set <em>options</em> as variables by using a special syntax.  Run the
following commands:</p>
<pre class="codehilite"><code class="language-vim">:set textwidth=80
:echo &amp;textwidth</code></pre>


<p>Vim will display <code>80</code>.  Using an ampersand in front of a name tells Vim that
you're referring to the option, not a variable that happens to have the same
name.</p>
<p>Let's see how Vim works with boolean options.  Run the following commands:</p>
<pre class="codehilite"><code class="language-vim">:set nowrap
:echo &amp;wrap</code></pre>


<p>Vim displays <code>0</code>.  Now try these commands:</p>
<pre class="codehilite"><code class="language-vim">:set wrap
:echo &amp;wrap</code></pre>


<p>This time Vim displays <code>1</code>.  This is a very strong hint that Vim treats the
integer <code>0</code> as "false" and the integer <code>1</code> as "true".  It would be reasonable to
assume that Vim treats <em>any</em> non-zero integer as "truthy", and this is indeed
the case.</p>
<p>We can also <em>set</em> options as variables using the <code>let</code> command.  Run the
following commands:</p>
<pre class="codehilite"><code class="language-vim">:let &amp;textwidth = 100
:set textwidth?</code></pre>


<p>Vim will display <code>textwidth=100</code>.</p>
<p>Why would we want to do this when we could just use <code>set</code>? Run the following
commands:</p>
<pre class="codehilite"><code class="language-vim">:let &amp;textwidth = &amp;textwidth + 10
:set textwidth?</code></pre>


<p>This time Vim displays <code>textwidth=110</code>.  When you set an option using <code>set</code> you
can only set it to a single literal value.  When you use <code>let</code> and set it as
a variable you can use the full power of Vimscript to determine the value.</p>
<h2 id="local-options">Local Options</h2>
<p>If you want to set the <em>local</em> value of an option as a variable, instead of the
<em>global</em> value, you need to prefix the variable name.</p>
<p>Open two files in separate splits.  Run the following command:</p>
<pre class="codehilite"><code class="language-vim">:let &amp;l:number = 1</code></pre>


<p>Now switch to the other file and run this command:</p>
<pre class="codehilite"><code class="language-vim">:let &amp;l:number = 0</code></pre>


<p>Notice that the first window has line numbers and the second does not.</p>
<h2 id="registers-as-variables">Registers as Variables</h2>
<p>You can also read and set <em>registers</em> as variables.  Run the following command:</p>
<pre class="codehilite"><code class="language-vim">:let @a = "hello!"</code></pre>


<p>Now put your cursor somewhere in your text and type <code>"ap</code>.  This command tells
Vim to "paste the contents of register <code>a</code> here".  We just set the contents of
that register, so Vim pastes <code>hello!</code> into your text.</p>
<p>Registers can also be read.  Run the following command:</p>
<pre class="codehilite"><code class="language-vim">:echo @a</code></pre>


<p>Vim will echo <code>hello!</code>.</p>
<p>Select a word in your file and yank it with <code>y</code>, then run this command:</p>
<pre class="codehilite"><code class="language-vim">:echo @"</code></pre>


<p>Vim will echo the word you just yanked.  The <code>"</code> register is the "unnamed"
register, which is where text you yank without specifying a destination will go.</p>
<p>Perform a search in your file with <code>/someword</code>, then run the following command:</p>
<pre class="codehilite"><code class="language-vim">:echo @/</code></pre>


<p>Vim will echo the search pattern you just used.  This lets you programmatically
read <em>and modify</em> the current search pattern, which can be very useful at times.</p>
<h2 id="exercises">Exercises</h2>
<p>Go through your <code>~/.vimrc</code> file and change some of the <code>set</code> and <code>setlocal</code>
commands to their <code>let</code> forms.  Remember that boolean options still need to be
set to something.</p>
<p>Try setting a boolean option like <code>wrap</code> to something other than zero or one.
What happens when you set it to a different number?  What happens if you set it
to a string?</p>
<p>Go back through your <code>~/.vimrc</code> file and undo the changes.  You should never use
<code>let</code> if <code>set</code> will suffice -- it's harder to read.</p>
<p>Read <code>:help registers</code> and look over the list of registers you can read and
write.</p></div>

        <div class="prevnext">
            
                <a class="prev" href="/chapters/18.html">&laquo; Previous</a>
            
            
                <a class="next" href="/chapters/20.html">Next &raquo;</a>
            
        </div>
    </section>


            <footer class="sixteen columns">
                Made by <a href="http://stevelosh.com">Steve Losh</a>.

                <a href="/license.html">License</a>.

                Built with
                <a href="http://bitbucket.org/sjl/bookmarkdown/">Bookmarkdown</a>.
            </footer>
        </div>

        
            <script type="text/javascript">
                var _gaq = _gaq || [];
                _gaq.push(['_setAccount', 'UA-15328874-8']);
                _gaq.push(['_trackPageview']);

                (function() {
                 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                 var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                 })();
            </script>
        

        
            <script type="text/javascript">
                var _gauges = _gauges || [];
                (function() {
                 var t   = document.createElement('script');
                 t.type  = 'text/javascript';
                 t.async = true;
                 t.id    = 'gauges-tracker';
                 t.setAttribute('data-site-id', '4e8f83b7f5a1f546e200000d');
                 t.src = '//secure.gaug.es/track.js';
                 var s = document.getElementsByTagName('script')[0];
                 s.parentNode.insertBefore(t, s);
                 })();
             </script>
        
    </body>
</html>
