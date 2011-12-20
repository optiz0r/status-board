<h1>Incident {$incident->reference|escape:html}</h1>

<div class="container">
    <div class="row">
        <div class="span16">
            <form id="admin_incident_edit" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/edit/">
                <fieldset>
                    <legend>Edit Incident</legend>
                    
                    <div class="clearfix">
                        <label for="admin_incident_edit_name">Reference</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_incident_edit_name" name="reference" type="text" value="{$incident->reference|escape:html}" />
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_incident_edit_description">Description</label>
                        <div class="text">
                            <textarea class="span12" id="admin_incident_edit_description" name="description">{$incident->description|escape:html}</textarea>
                        </div>
                    </div><!-- /clearfix -->

                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Edit Incident">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
    
    <div class="row">
        <div class="span16">
            <form id="admin_incident_changestatus" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/change-status/">
                <fieldset>
                    <legend>Change Status</legend>
                    
                    <div class="clearfix">
                        <label for="admin_incident_changestatus_status">New Status</label>
                        <div class="select">
                            <select class="xlarge span5" id="admin_incident_changestatus_status" name="status">
                                {foreach from=StatusBoard_Status::available() item=status}
                                    <option value="{$status}">{StatusBoard_Status::name($status)}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div><!-- /clearfix -->
                    
                                        <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Edit Incident">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
</div><!-- /container -->

<h2>Status Changes</h2>

<table>
    <thead>
        <th>Date/Time</th>
        <th>Status</th>
    </thead>
    <tbody>
        {foreach from=$statuses item=status}
            <tr>
                <td>
                    {StatusBoard_DateTime::fuzzyTime($status->ctime)}<br />
                    <em>{$status->ctime|date_format:'y-m-d h:i:s'}</em>
                </td>
                <td>{StatusBoard_Status::name($status->status)}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
