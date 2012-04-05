class PagesController < ApplicationController

  def home
    @title = "Home"
    @members = Member.all
    @announcements = Announcement.find(:all, :conditions => ["status = ?", "sent"], :limit => 5, :order => 'sent_at DESC')
    @links = Link.find_all_by_show_home(true, :order => "name")
    @checklist1 = Document.find_all_by_name("SKX Environment Setup Checklist")
    @checklist2 = Document.find_all_by_name("Project Setup Checklist")
    @documents = Document.find_all_by_show_home(true, :order => "name")
  end

  def daprotocol

  end

end
