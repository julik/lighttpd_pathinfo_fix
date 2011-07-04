# Lighttpd sets the wrong SCRIPT_NAME and PATH_INFO if you mount your
# FastCGI app at "/".
# This middleware fixes this issue. This is also
# modified to account for the case when SCRIPT_NAME is the name of the 404 script
class LighttpdPathinfoFix
  VERSION = '1.0.1'
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    return @app.call(env) unless env["FCGI_ROLE"] && (env["SERVER_SOFTWARE"] =~ /lightt/i)
    return @app.call(env) unless env["PATH_INFO"].nil? || env["PATH_INFO"].empty?
    
    # Retreive the actual URI
    uri, qs = env["REQUEST_URI"].to_s.split('?')
    
    # Ensure URI has a leading slash
    uri = "/#{uri}" unless uri =~ /^\//
    munged_env = env.merge("PATH_INFO" => uri, "QUERY_STRING" => qs, "SCRIPT_NAME" => "")
    
    @app.call(munged_env)
  end
end