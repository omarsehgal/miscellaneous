class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_idsid

  def get_idsid
    session[:idsid] = "osehgal"
    if session[:idsid].nil?
      if !params[:u].nil?
        user = params[:u]
        session[:idsid] = user
        @current_user = user

        if Member.find(:all, :conditions => ["idsid = '#{session[:idsid]}' and dbadmin = 1"]).present?
          session[:admin] = true
        end

        # if the user had entered the site initially with a specific URL (before
        # being redirected for authentication), redirect to there
        if session[:redirect_url].present?
          redirect_to session[:redirect_url]
        end
      else
        if ENV['RAILS_ENV'].eql?"production"
          session[:redirect_url] = request.url
          redirect_to "http://da-iteam.sc.intel.com/cgi-bin/whoisit.cgi"
        else
          session[:redirect_url] = request.url
          redirect_to "http://da-iteam.sc.intel.com/cgi-bin/whoisit_dev.cgi"
        end
      end
    end
  end

  helper_method :get_idsid

end
