# Lighttpd sets the wrong SCRIPT_NAME and PATH_INFO if you mount your
# FastCGI app at "/".
# This middleware fixes this issue. This is also
# modified to account for the case when SCRIPT_NAME is the name of the 404 script
class LighttpdPathinfoFix
  VERSION = '1.0.2'
  DBG = 'DEBUG_LIGHTTPD_PATH_INFO_FIX'
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    unless env["SERVER_SOFTWARE"].to_s =~ /lightt/i
      inform("Skipping lighttpd pathinfo fix this since this is not a Lighttpd install")
      return @app.call(env)
    end
    
    unless env["PATH_INFO"].to_s.empty?
      inform("Skipping lighttpd pathinfo fix - PATH_INFO was #{env["PATH_INFO"]}")
      return @app.call(env)
    end
    
    # Retreive the actual URI
    uri, qs = env["REQUEST_URI"].to_s.split('?')
    
    # Ensure URI has a leading slash
    uri = "/#{uri}" unless uri =~ /^\//
    munged_env = env.merge("PATH_INFO" => uri, "QUERY_STRING" => qs, "SCRIPT_NAME" => "")
    inform("Munged PATH_INFO to be #{uri}")
    
    @app.call(munged_env)
  end
  
  private
  
  def inform(msg)
    if ENV[DBG]
      File.open("/tmp/lighttpd_pathinfo_fix.log", "w") {|f| f.write(msg) }
    end
  end
end