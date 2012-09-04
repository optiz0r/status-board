<?php

class StatusBoard_DateTime extends SihnonFramework_DateTime {

    public static function timeAgo($time) {
        $full = date('r', $time);
        $readable = date('y-m-d H:i:s', $time);
        return <<<END
<time class="timeago" datetime="{$full}">{$readable}</time>
END;
    }
}

?>