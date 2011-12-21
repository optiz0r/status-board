<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <title>Status Board</title>
        <script lang="javascript">
        </script>
        <link rel="stylesheet" type="text/css" href="{$base_uri}styles/normal.css" />
        
        <script type="text/javascript">
            var base_uri = "{$base_uri|escape:'quote'}";
            var base_url = "{$base_url|escape:'quote'}";
        </script>
        
        <link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/smoothness/jquery-ui.css" rel="Stylesheet" />
        <link type="text/css" href="{$base_uri}styles/3rdparty/jquery.asmselect.css" rel="Stylesheet" />	
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
		<script type="text/javascript" src="{$base_uri}scripts/main.js"></script>
        <link rel="stylesheet/less" href="{$base_uri}less/bootstrap.less" media="all" />
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/less-1.1.5.min.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-alerts.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-twipsy.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-popover.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-dropdown.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-tabs.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap-modal.js"></script>
    </head>
    <body>

        <div class="topbar">
            <div class="topbar-inner">
                <div class="container-fluid">
                    {$page->include_template('navigation')}
                </div><!-- /tobar-inner -->
            </div><!-- /container-fliud -->
        </div><!-- /topbar -->
        

        <div class="container">
            <div class="content">

                {if $messages}
                    <div id="messages">
                        {foreach from=$messages item=message}
                            {if is_array($message)}
                                {$severity=$message['severity']}
                                <div class="alert-message {$severity}">
                                    {$message['content']|escape:html}
                                </div>
                            {else}
                                <div class="alert-message info">
                                    {$message|escape:html}
                                </div>
                            {/if}
                        {/foreach}
                    </div><!-- /messages -->
                {/if}

                {$page_content}

            </div><!-- /content -->

            <footer>
              <p> Powered by <a href="https://github.com/optiz0r/status-board/wiki" title="StatusBoard Wiki">StatusBoard</a> {$version} ({$version_codename}). Written by Ben Roberts and Nathan Booth.</p>          
            </footer>

        </div><!-- /container -->
    </body>
</html>