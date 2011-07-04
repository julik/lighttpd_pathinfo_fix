require "test/unit"
require "lighttpd_pathinfo_fix"
require "flexmock"
require "flexmock/test_unit"

class TestLighttpdPathinfoFix < Test::Unit::TestCase
  def setup
    @app = flexmock()
    @fix = LighttpdPathinfoFix.new(@app)
  end
  
  def test_bypassed_with_differing_server_name
    source_env = {
    "FCGI_ROLE"=>"RESPONDER",
    "SERVER_SOFTWARE"=>"coffeepot",
    "SCRIPT_NAME"=>"/config.ru",
    "PATH_INFO"=>"",
    "SCRIPT_FILENAME"=>"/Code/apps/flame_bacula_search/config.ru",
    "DOCUMENT_ROOT"=>"/Code/apps/flame_bacula_search",
    "REQUEST_URI"=>"/",
    "REDIRECT_URI"=>"/config.ru",
    "QUERY_STRING"=>"",
    "REQUEST_PATH"=>"/"
    }
    @app.should_receive(:call).with(source_env).once
    @fix.call(source_env)
  end
  
  def test_root_path_properly_munged_on_root_path
    source_env = {
    "FCGI_ROLE"=>"RESPONDER",
    "SERVER_SOFTWARE"=>"lighttpd/1.4.19",
    "SCRIPT_NAME"=>"/config.ru",
    "PATH_INFO"=>"",
    "SCRIPT_FILENAME"=>"/Code/apps/flame_bacula_search/config.ru",
    "DOCUMENT_ROOT"=>"/Code/apps/flame_bacula_search",
    "REQUEST_URI"=>"/",
    "REDIRECT_URI"=>"/config.ru",
    "QUERY_STRING"=>"",
    "REQUEST_PATH"=>"/"
    }
    
    
    dest_env = {
    "FCGI_ROLE"=>"RESPONDER",
    "SERVER_SOFTWARE"=>"lighttpd/1.4.19",
    "SCRIPT_NAME"=>"",
    "PATH_INFO"=>"/",
    "SCRIPT_FILENAME"=>"/Code/apps/flame_bacula_search/config.ru",
    "DOCUMENT_ROOT"=>"/Code/apps/flame_bacula_search",
    "REQUEST_URI"=>"/",
    "REDIRECT_URI"=>"/config.ru",
    "QUERY_STRING"=>nil,
    "REQUEST_PATH"=>"/"
    }
    
    @app.should_receive(:call).with(dest_env).once
    @fix.call(source_env)
  end
  
  def test_root_path_properly_munged_with_querystring_params
    source = {"FCGI_ROLE"=>"RESPONDER", "SERVER_SOFTWARE"=>"lighttpd/1.4.19",
      "SCRIPT_NAME"=>"/config.ru", "PATH_INFO"=>"",
      "SCRIPT_FILENAME"=>"/Code/apps/flame_bacula_search/config.ru",
      "DOCUMENT_ROOT"=>"/Code/apps/flame_bacula_search",
      "REQUEST_URI"=>"/?foo=bar", "REDIRECT_URI"=>"/config.ru", "QUERY_STRING"=>"", "REQUEST_PATH"=>"/"}
    dest = {"FCGI_ROLE"=>"RESPONDER", "SERVER_SOFTWARE"=>"lighttpd/1.4.19",
      "SCRIPT_NAME"=>"", "PATH_INFO"=>"/", "SCRIPT_FILENAME"=>"/Code/apps/flame_bacula_search/config.ru",
      "DOCUMENT_ROOT"=>"/Code/apps/flame_bacula_search", "REQUEST_URI"=>"/?foo=bar",
      "REDIRECT_URI"=>"/config.ru", "QUERY_STRING"=>"foo=bar", "REQUEST_PATH"=>"/"}
    
    @app.should_receive(:call).with(dest).once
    @fix.call(source)
  end
  
end
