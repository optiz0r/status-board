<h2>An unhandled error has occurred</h2>
<p>
	There was a problem trying to complete the requested action. Please try again and if the problem persists, let us know.
</p>

{if $display_exceptions}
<p>
	An unhandled exception was caught during the page template processing. The full details are shown below:
</p>
<div class="container">
    <div class="row">
        <div class="span4 column">
           <h2>Exception</h2>
        </div>
        <div class="span11 column">
            {$exception_type|escape:html}
        </div>
    </div>
        
	<div class="row">
    	<div class="span4 column">
        	<h2>File</h2>
        </div>
        <div class="span11 column">
			{$exception->getFile()|escape:html}
		</div>
	</div>
        
    <div class="row">
        <div class="span4 column">
   			<h2>Line</h2>
        </div>
        <div class="span11 column">
			{$exception->getLine()}
		</div>
	</div>
		
	<div class="row">
    	<div class="span4 column">
			<h2>Message</h2>
        </div>
        <div class="span11 column">
			{$exception->getMessage()}
		</div>
	</div>
		
	<div class="row">
    	<div class="span4 column">
        	<h2>Stack Trace</h2>
        </div>
        <div class="span11 column">
			{$exception->getTrace()|var_dump}
		</div>
	</div>
</div>

<p>
	<em>Note:</em> Exception details should not be displayed on production systems.
	Disable the <a href="{$base_uri}admin/tab/settings/"><code>Display Exceptions</code></a>
	setting to omit the exception details from this page.
</p>
{/if} 