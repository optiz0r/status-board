<?php

require 'smarty/Smarty.class.php';

class StatusBoard_Main extends SihnonFramework_Main {
    
    const TEMPLATE_DIR = '../source/webui/templates/';
    const CODE_DIR     = '../source/webui/pages/';

    protected static $instance;

    protected $smarty;
    protected $request;

    protected function __construct() {
        parent::__construct();
    }
    
    protected function init() {
        parent::init();
        
        $request_string = isset($_GET['l']) ? $_GET['l'] : '';
        
        $this->request  = new StatusBoard_RequestParser($request_string, self::TEMPLATE_DIR, self::CODE_DIR);
        
        switch (StatusBoard_File) {
            case 'ajax':
            case 'index': {
                $smarty_tmp = $this->config->get('templates.tmp_path');
                $this->smarty = new Smarty();
                $this->smarty->addTemplateDir(static::makeAbsolutePath(self::TEMPLATE_DIR));
                $this->smarty->setCompileDir(static::makeAbsolutePath($smarty_tmp . '/templates'));
                $this->smarty->setCacheDir(static::makeAbsolutePath($smarty_tmp . '/cache'));
                $this->smarty->addConfigDir(static::makeAbsolutePath($smarty_tmp . '/config'));
                $this->smarty->addPluginsDir(static::makeAbsolutePath('../source/smarty/plugins'));
                 
                $this->smarty->registerPlugin('modifier', 'formatDuration', array('StatusBoard_Main', 'formatDuration'));
                $this->smarty->registerPlugin('modifier', 'formatFilesize', array('StatusBoard_Main', 'formatFilesize'));
                $this->smarty->registerPlugin('modifier', 'fuzzyTime', array('StatusBoard_DateTime', 'fuzzyTime'));
                $this->smarty->registerPlugin('modifier', 'timeago', array('StatusBoard_DateTime', 'timeAgo'));
                
                $this->smarty->assign('version', '2.0.0');
                $this->smarty->assign('version_codename', 'Bilberry');
                $this->smarty->assign('messages', array());
                 
                $this->smarty->assign('base_uri', $this->base_uri);
                $this->smarty->assign('base_url', static::absoluteUrl(''));
        
            } break;
        
        }
        
        // ensure the selected authentication backend implements the required features
        $this->auth->checkFeatures(array(
            'SihnonFramework_Auth_IDetails',
            'SihnonFramework_Auth_IFinelyPermissionable',
            'SihnonFramework_Auth_IUpdateable'
        ));
    }

    public function smarty() {
        return $this->smarty;
    }

    /**
     *
     * @return StatusBoard_RequestParser
     */
    public function request() {
        return $this->request;
    }


}

?>
