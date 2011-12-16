<h2>An unhandled error has occurred</h2>
<p>
	There was a problem trying to complete the requested action. Please try again and if the problem persists, let us know.
</p>

{if $display_exceptions}
<p>
	An unhandled exception was caught during the page template processing. The full details are shown below:
</p>
<table class="exception-details">
	<colgroup id="header">
		<col />
	</colgroup>
	<colgroup>
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th>Exception</th>
			<td>{$exception_type}</td>
		</tr>
		<tr>
			<th>File</th>
			<td>{$exception->getFile()}</td>
		</tr>
		<tr>
			<th>Line</th>
			<td>{$exception->getLine()}</td>
		</tr>
		<tr>
			<th>Message</th>
			<td>{$exception->getMessage()}</td>
		</tr>
		<tr>
			<th>Stack Trace</th>
			<td><pre>{$exception->getTrace()|print_r}</pre></td>
		</tr>
	</tbody>
</table>

<p>
	<em>Note:</em> Exception details should not be displayed on production systems.
	Disable the <a href="{$base_uri}admin/settings/key/debug.show_exceptions/"><code>debug.show_exceptions</code></a>
	setting to omit the exception details from this page.
</p>
{/if} 