<!DOCTYPE HTML>
<html>
    <head>
        <title>Status Board</title>
        <link rel="shortcut icon" href="{$base_uri}images/favicon.ico" />
        
        <script type="text/javascript">
            var base_uri = "{$base_uri|escape:'quote'}";
            var base_url = "{$base_url|escape:'quote'}";
        </script>
        
        <!-- JQuery -->
        <link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/smoothness/jquery-ui.css" rel="Stylesheet" />
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>

        <!-- Bootstrap -->
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/less-1.1.5.min.js"></script>
        <link rel="stylesheet/less" href="{$base_uri}less/bootstrap.less" media="all" />
        <link type="text/css" rel="stylesheet" href="{$base_uri}styles/bootstrap.min.css" />
        <script type="text/javascript" src="{$base_uri}scripts/3rdparty/bootstrap.min.js"></script>
        
        <!-- Local -->
        <link rel="stylesheet" type="text/css" href="{$base_uri}styles/normal.css" />
        <script type="text/javascript" src="{$base_uri}scripts/sihnon-js-lib/sihnon-framework.js"></script>
        <script type="text/javascript" src="{$base_uri}scripts/main.js"></script>
    </head>
    <body>

        <div class="navbar navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container-fluid">
                    {$page->include_template('navigation')}
                </div>
            </div>
        </div><!-- /navbar -->

        <div class="container content">

            {if ! $messages}
                {$session = StatusBoard_Main::instance()->session()}
                {$messages = $session->get('messages')}
                {$session->delete('messages')}
            {/if}
            {if $messages}
                <div class="row">
                    <div class="span12" id="messages">
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
                </div>
            {/if}

            <article id="content">
                {$page_content}
            </article>

        </div><!-- /container content -->
        
        <footer>
            Powered by 
            <a href="https://github.com/optiz0r/status-board/wiki" title="StatusBoard Wiki">StatusBoard</a> {$version} ({$version_codename}).
            Written by Ben Roberts and Nathan Booth.          
        </footer>
    </body>
</html>