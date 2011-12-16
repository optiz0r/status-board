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
    </head>
    <body>

        <div id="container">

            <div id="banner">
                <h1>StatusBoard</h1>
            </div>

            <div id="navigation">
                {include file="navigation.tpl"}
            </div>

            <div id="page-container">
            
                <div id="sidebar">
                    {include file="sidebar.tpl"}
                </div>

                <div id="page">

                    {if $messages}
                        <div id="messages">
                            {foreach from=$messages item=message}
                                {$message}
                            {/foreach}
                        </div>
                    {/if}

                    {$page_content}

                </div>

            </div>

            <div id="footer">
                Powered by StatusBoard {$version}. Written by Ben Roberts and Nathan Booth.
            </div>

        </div>
    </body>
</html>
