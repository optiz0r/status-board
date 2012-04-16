<div class="row">

	<div class='span10'>
	  <h1 class='lead'>
        <strong>{$site_title}</strong> 
      </h1>
      <p>Service Status Dashboard, detailing your current,past and future service status
      </p>
    </div>
        
    <div class="span2 align-right">
        {if $display_admin_links}<a href="{$base_uri}admin/add-incident/" class="btn"><i class="icon-plus"></i> Add Incident</a>{/if}
    </div>
</div>

<div class="row">
	<div class="span2">
	<h5>Upcoming maintenance:</h5>
	</div>
    <div class="span10">
                <ul id="ticker">
                    <li>
                        <a href="#">
                         Service X1    
                        </a>
                        <p>Description</p>
                    </li>
                     <li>
                        <a href="#">
                         Service X2    
                        </a>
                        <p>Description</p>
                    </li>
					<li>
                        <a href="#">
                         Service X3  
                        </a>
                        <p>Description</p>
                    </li>
                   <li>
                        <a href="#">
                         Service X4    
                        </a>
                        <p>Description</p>
                    </li>
                </ul>
            </div>
         <div class="span12">
         {switch $home_output}
	         {case 'site'}
	         	{$page->include_template('fragments/home-site')}
         		{/case} 
         	{default}
         		{$page->include_template('fragments/home-service')}  
         {/switch}
	    </div>
</div><!-- row -->