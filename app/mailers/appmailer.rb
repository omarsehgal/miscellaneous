class Appmailer < ActionMailer::Base
  #add_template_helper(ApplicationHelper)
  default :from => "dbadmin@sc.intel.com"
  @@footer = "Announcement sent via 'iTeam Announcements Page for DA' (http://goto/iteam)"
  #add_template_helper(ApplicationHelper)
  helper :application

  def new_post(cat_owner, cat_name, user, title)
    @user = user
    @category_name = cat_name
    @post = title

    # there can be many category owners separated by commas osehgal,szhong1,ylee88,etc.
    owners = cat_owner.split(',')
    addresses = ""
    owners.each do |o|
      email = get_email_from_idsid(o)
      if email.present?
        addresses += email + ','
      else
        mail(:to => "omar.sehgal@intel.com", :subject => "Failed to get email address of category owner: #{cat_owner}")
      end
    end

    mail(:to => addresses, :subject => "DADesk: #{user} added a new post to #{cat_name}") do |format|
      format.html
    end
  end

  def new_announcement(announcement)
    @announcement = announcement
    addresses = @announcement.email_list.split(';')
    cc = @announcement.cc_list
    cc = cc.to_i

    if !@announcement.attachment_file_name.nil?
      attachments[@announcement.attachment_file_name] = File.read("public/#{@announcement.attachment.url}")
    end

    if cc == 1
      mail(:to => addresses, :from => @announcement.from_email, :cc => @announcement.from_email, :subject => @announcement.title) do |format|
        format.html
    end
    else
      mail(:to => addresses, :from => @announcement.from_email, :subject => @announcement.title) do |format|
        format.html
      end
    end

  end

  def announcement_link (announcement)
    link = announcement.url
    link = "http://scyweb05.sc.intel.com:3008/" + link
    return link
  end

  def new_project_user_request (project_user)
    @project_user = project_user
    submitter = get_email_from_idsid(@project_user.name)
    #submitter = "eleanor.lee@intel.com"
   subject_line = "Your Request to Join " + @project_user.project + " Has Been Received"
    mail(:to => submitter, :bcc => "eleanor.lee@intel.com", :subject => subject_line) do |format|
      format.html
    end
  end

  def send_to_sponsor (project_user)
    @project_user = project_user
    sponsor = get_email_from_idsid(@project_user.sponsor)
    #sponsor = "eleanor.lee@intel.com"
    subject_line = "Sponsor Manager Approval for "+ get_full_name(@project_user.name)
    mail(:to => sponsor, :bcc => "eleanor.lee@intel.com", :subject => subject_line) do |format|
      format.html
    end
  end

  def sponsor_approved_notice (project_user)
    @project_user = project_user
    subject_line = "Sponsor Manager Approved for "+ get_full_name(@project_user.name)
    mail(:to => "eleanor.lee@intel.com", :subject => subject_line) do |format|
      format.html
    end
  end

  def complete_project_user_request (project_user)
    @project_user = project_user
    submitter = get_email_from_idsid(@project_user.name)
    subject_line = "Your Request to Join " + @project_user.project + " Has Been Completed"
    if(@project_user.user_type.eql?"Member")
      mail(:to => submitter, :bcc => "eleanor.lee@intel.com", :subject => subject_line) do |format|
        format.html
      end
    else
    sponsor = get_email_from_idsid(@project_user.sponsor)
    #sponsor = "eleanor.lee@intel.com"
      mail(:to => submitter, :cc => sponsor, :bcc => "eleanor.lee@intel.com", :subject => subject_line) do |format|
        format.html
      end
    end
  end

  def send_denied_notice (project_user, denier_idsid)
    @project_user = project_user
    subject_line = "Your Request to Join " + @project_user.project + " Has Been Denied"
    submitter = get_email_from_idsid(@project_user.name)
    denier = get_email_from_idsid(denier_idsid)
    @denier_idsid = denier_idsid
    if @project_user.user_type.eql?"Member"
      mail(:from => denier, :to => submitter, :bcc => "eleanor.lee@intel.com",:subject => subject_line) do |format|
        format.html
      end
    else
      sponsor = get_email_from_idsid(@project_user.sponsor)
      mail(:from => denier, :to => submitter, :cc => sponsor, :bcc => "eleanor.lee@intel.com", :subject => subject_line) do |format|
        format.html
      end
    end
  end

    def get_email_from_idsid(user)
    email = `cdislookup -i #{user} | grep DomainAddress | awk '{print $3}'`
    if email.present?
      email = email.chomp
    end

    return email
  end

    def get_full_name (user)
    name = ""
    lname = `cdislookup -i #{user} | grep Lname | awk '{print $3}'`
    nname = `cdislookup -i #{user} | grep Nickname | awk '{print $3}'`
    fname = `cdislookup -i #{user} | grep Fname | awk '{print $3}'`
    fname = fname.chomp
    lname = lname.chomp
    nname = nname.chomp
    if nname.blank?
      name = fname.humanize + ' ' + lname.humanize
    else
      name = fname.humanize + ' (' + nname.humanize + ') ' + lname.humanize
    end
    unless name == ""
      return name
    end
      return user
    end

      def get_email_name(user)
    name = ""
    nname = `cdislookup -i #{user} | grep Nickname | awk '{print $3}'`
    if nname.blank?
      fname = `cdislookup -i #{user} | grep Fname | awk '{print $3}'`
      name = fname.chomp
    else
      name = nname.chomp
    end
    unless name == ""
      name = name.humanize
      return name
    end
      end

end

