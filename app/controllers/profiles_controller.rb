class ProfilesController < InheritedResources::Base
  include Utils
  require 'RMagick'
  #before_filter :authenticate_user!, :confirm_registration!

  # called when create profile is called
  def new
    # the create profile page is only for registered users
    # and is supposed to be completed only once..check for this two items
    if user_signed_in? and current_user.present?
      if current_user.profile.full_profile_at.present?
        redirect_to profile_path(current_user.profile)
        return
      end
    else
      # redirect to some sort of error
      redirect_to home_path
      return
    end

    @profile = Profile.new
    @profile.user = current_user
    @linkedin_profile = current_user.linkedin.profile #(nil,'num-connections,num-recommenders,id')
    @suggested_login = @profile.suggest_login(current_user.first_name, current_user.last_name)

    unless @linkedin_profile.positions.empty?
      unless @linkedin_profile.positions.first.company.nil?
        unless @linkedin_profile.positions.first.company.id.nil?
          @first_company_info = current_user.linkedin.companyLookup(@linkedin_profile.positions.first.company.id)
        end
      end
    end
  end

  # when on another person's profile page, to send the person a message
  # this is called when the "send message" action is clicked on
  # opens the message form
  def show_message_form
    @user = User.find(params[:to_uid])
    render :layout => false
  end

  def send_message
    receiver = User.find(params[:uid].to_i)
    subject = params[:subject]
    body = params[:body]
    to_first_name = receiver.first_name
    to_email = receiver.email
    # send email with the message to the user
    SneakPeekMailer.delay.message_email(to_email, to_first_name, subject, "#{body}", current_user.full_name)
    render :nothing => true
  end

  # when on another person's profile page, to send the person a connection request
  # this is called when the "connect with" action is clicked on
  # opens the connection form..below method sends the connection request
  def show_connect_form
    if params[:award].present?
      @connect_for_award = true
    end
    @user = User.find(params[:uid])
    render :partial => "profile_connect_with", :layout => false
  end


  def send_connection_request
    receiver = User.find(params[:to].to_i)
    subject = params[:subject]
    body = params[:body]
    # call the connections API and send connect request to the user
    current_user.linkedin.sendInvite(receiver.first_name, receiver.last_name, receiver.email, subject, body)
    render :nothing => true
  end

  # toggle of the like action on the profile page
  def change_like
    user = User.find(params[:id])
    if current_user.likes?(user)
      msg = "I <span>like</span> this profile"
      Like.delay.delete_all(["user_id = ? and likeable_id = ? and likeable_type = ?", current_user.id, user.id, "User"])
      NetworkUpdate.removeLikedUpdate(current_user.id, user.id)
    else
      current_user.like!(user)
      msg = "Remove <span>like</span>"
      NetworkUpdate.delay.createLikedUpdate(current_user.id, user.id)
      SneakPeekMailer.delay.like_email(current_user, user)
    end
    render :text => msg
  end

  # toggle of the interest action on the profile page
  def change_interest
    user = User.find(params[:id])
    if current_user.interested?(user)
      msg = "I'm <span>interested</span> in this profile"
      Interest.delay.delete_all(["user_id = ? and interestable_id = ? and interestable_type = ?", current_user.id, user.id, "User"])
      NetworkUpdate.removeInterestedUpdate(current_user.id, user.id)
    else
      msg = "Remove <span>interest</span> in profile"
      current_user.interest!(user)
      NetworkUpdate.delay.createInterestedUpdate(current_user.id, user.id)
      SneakPeekMailer.delay(:queue => 'mailers').interested_email(current_user, user)
    end
    render :text => msg
  end

  def validate_create_profile
    @profile = current_user.profile
    if params[:login].present?
      login = params[:login]
      if !@profile.login_available?(login)
        render :text => "Login already in use. Please try another"
      else
        render :nothing => true
      end
    end
    if params[:email].present?
      email = params[:email]
      if !@profile.email_available?(email)
        render :text => "Email already in use. Please try another"
      else
        render :nothing => true
      end
    end
  end

  def refresh_data
    @profile = current_user.profile
    type = params[:type]
    render :partial => "profile_#{type}_form"
  end

  def refresh_card_data
    @profile = current_user.profile
    type = params[:type]
    render :partial => "profile_card_#{type}_edit"
  end

  def refresh_tabs_data
    @profile = current_user.profile
    type = params[:type]
    render :partial => "profile_#{type}_edit"
  end

  def not_found(msg)
    raise ActionController::RoutingError.new(msg)
  end

  # displays user profiles
  def show
    Google_analytics.new.pageImpression("Profile", "MyProfile")

    if params[:login].present? # when someone comes in with http://www.blinkup.com/username
      @user = User.find_by_login(params[:login]) || not_found("Unknown username")
      @profile = @user.profile
    elsif params[:id].present?
      begin
        @profile = Profile.find(params[:id])
      rescue
        raise ActiveRecord::RecordNotFound
      end
      @user = @profile.user
    else
      not_found("Unknown entry point")
    end

    @own_view = false
    # identify if the user is viewing him/her self
    if user_signed_in? and current_user.present?
      if @user == current_user
        # set the view to own unless the user him/her self is requesting to see the profile in view mode
        if params[:pm].present? and params[:pm].to_i == 0
          @own_view_in_view_mode = true
        else
          @own_view = true
        end
      end

      # also make a record of the profile visit
      if @user.id != current_user.id
        NetworkUpdate.delay.createVisitUpdate(current_user.id, @user.id, true)
        v = Visitor.new
        v.user_id = @user.id
        v.visitor_user_id = current_user.id
        v.save!
      end
    end

    dc = get_cached_server
    # search the cache for the linkedin profile and if not there, save it
    # we only need to pull linkedin info when viewing the limited profile of another person
    if @profile.full_profile_at.nil?
      @linkedin_profile = Profile.linkedin_cached_get_by_user_id(:dalli => dc, :user_id => @user.id)
    end

    # stuff to get profile awards loaded
    @award_categories = AwardCategory.cached_get_all(:dalli => dc)
    @award_aggrs = UserAwardAggr.where(:user_id => @user.id)
    @work_count = 3

    # this will get the number of awards the profile person has
    @current_user_total_accepted_award_count = UserAwardAggr.total_accepted_awards(@user.id)

    # this gets the needed info for the profile recommendation section
    @award_transactions = AwardTransaction.award_recommendations(@user.id)

    # the like/visit numbers that appear next to the profile picture. show unique likes/visits in the last 90 days
    @like_count_in_past_90 = Like.count(:all, :select => 'DISTINCT user_id', :conditions => ["likeable_type = 'User' and likeable_id = #{@user.id} and created_at >= ?", 90.days.ago])
    @visitor_count_in_past_90 = Visitor.count(:all, :select => 'DISTINCT visitor_user_id', :conditions => ["user_id = #{@user.id} and created_at >= ?", 90.days.ago])

    # the following follows an algorithm to find people who show up in the people who like me section
    @likers = @profile.find_likes(@user.id, current_user)
    @visitors = Visitor.find(:all, :select => 'DISTINCT visitor_user_id', :conditions => ["user_id = #{@user.id}"])

    if user_signed_in? and current_user.present?
      # make a record of the profile visit but don't count own profile visit
      if !@own_view and !@own_view_in_view_mode
        NetworkUpdate.create(:actor_id => current_user.id, :action_id => 1, :recipient_id => @user.id, :content => "View", :source => "Blinkup")
        v = Visitor.new
        v.user_id = @user.id
        v.visitor_user_id = current_user.id
        v.save!
      end
    end

    # rollup all the tips
    @tip = ProfileTip.find(:all, :conditions => ["profile_id = #{@profile.id} and profile_tip_type = 'tip'"]).first
    @book = ProfileTip.find(:all, :conditions => ["profile_id = #{@profile.id} and profile_tip_type = 'business_book'"]).first
    @quote = ProfileTip.find(:all, :conditions => ["profile_id = #{@profile.id} and profile_tip_type = 'business_quote'"]).first
    @website = ProfileTip.find(:all, :conditions => ["profile_id = #{@profile.id} and profile_tip_type = 'website'"]).first

    # this finds out if the profile visitor has given an award to the profile person or not
    @awarded_by_profile_visitor = false
    if user_signed_in? and current_user.present?
      given = AwardTransaction.gave_award_to?(:giver_id => current_user.id, :receiver_id => @user.id)
      if given
        @awarded_by_profile_visitor = true
      end
    end

    if @own_view
      # the following keeps track of profile view/edit mode for the current user
      @edit_mode = true
      if params[:pf].present?
        @edit_mode = params[:pf].to_i
      end
    else
      @work_count_card = 3
      @is_connected = @user.linkedin.people_search("#{@profile.full_name}", "id,first-name,last-name,picture-url,headline")
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    Google_analytics.new.pageImpression("Profile", "CreateProfile")
    @profile = current_user.profile

    # to make sure the user is not hitting the back button and creating a profile again
    if @profile.full_profile_at.present?
      redirect_to profile_path(@profile)
      return
    end

    @linkedin_profile = current_user.linkedin.profile

    @user = current_user
    @user.gender = params[:user][:gender]
    unless params[:user][:birth_month].empty? or params[:user][:birth_day].empty?
      @user.birthday = Date.new(params[:user][:birth_year].to_i, params[:user][:birth_month].to_i, params[:user][:birth_day].to_i)
    end
    @user.login = params[:user][:login]
    @user.email = params[:user][:email]

    begin
      @user.save!
    rescue ActiveRecord::RecordInvalid => e
      if e.message =~ /Email has already been taken/
        @profile.errors.add(:base, "Email already in use. Please select another")
      elsif e.message =~ /Login has already been taken/
        @profile.errors.add(:base, "Login already in use. Please select another")
      end
    end

    # Populate stuff that couldn't be done automatically
    # Fill order of profile skills, should be made prettier
    order = 1
    %w{ skills certifications languages specialties associations }.each do |attrs|
      sel = eval("params[:profile][:profile_#{attrs}_attributes]") || []
      sel.each do |k,attr|
        if not attr[:name].empty?
          attr[:order] = order
          attr[:profile_id] = @profile.id
          order = order + 1
        end
      end
    end

    @profile.update_attributes(params[:profile])
    @profile.full_profile_at = Time.now
    @profile.summary = @linkedin_profile.summary
    @profile.user_id = current_user.id
    @profile.connections_count = @linkedin_profile.num_connections
    @profile.recommenders_count = @linkedin_profile.recommenders_count

    if @profile.save!
      ## start with positions
      Position.delete_all("profile_id = #{@profile.id}") # remove the one position created during registration
      # copy all positions from linkedin to profile and make the one selected on create profile as primary
      @linkedin_profile.positions.each do |p|
        position = Position.new
        position.title = p.title
        position.summary = p.summary
        position.company = Company.find_or_create_by_name(p.company.name) if p.company.present?
        position.is_default = 0

        # user entered custom values for this particular position
        if p.id.to_i == params[:position][:id].to_i
          position.company.url = params[:position][:url]
          position.company_size = CompanySize.find(params[:position][:size])
          position.job_function = JobFunction.find(params[:position][:function]) if params[:position][:function] != ""
          position.job_level = JobLevel.find(params[:position][:level]) if params[:position][:level] != ""
          position.is_default = 1
        end
        if p.is_current
          position.state = "current"
        end
        position.start_date = Date.new(p.start_date_year, p.start_date_month || 1, 1) if p.start_date_year.present?
        position.end_date = Date.new(p.end_date_year, p.end_date_month || 1, 1) if p.end_date_year.present?
        position.profile = @profile
        position.company.save
        position.save!
      end

      # copy all educations from linkedin to profile and make the one selected on create profile as primary
      @linkedin_profile.educations.each do |e|
        education = Education.new
        education.degree = e.degree
        education.notes = e.notes
        education.activities = e.activities
        education.start_date = Date.new(e.start_date_year, e.start_date_month  || 1, 1) if e.start_date_year.present?
        education.end_date = Date.new(e.end_date_year, e.end_date_month    || 1, 1) if e.end_date_year.present?
        education.school = School.find_or_create_by_name(e.school_name) if e.school_name.present?
        education.profile = @profile
        if params[:education][:id].to_i == e.id.to_i
          education.is_default = 1
        else
          education.is_default = 0
        end
        education.save!
      end

      # there should already be a location from the registration step
      if @profile.location.present?
        @location = @profile.location
      else
        @location = Location.new
        @profile.location = @location
      end
      @location.city = params[:location][:city]
      @location.state = params[:location][:state]
      @location.zip_code = params[:location][:zip_code]
      @location.country = Country.find(params[:location][:country])
      @location.save!
      @profile.save!

      redirect_to profile_path(@profile)
    else
      @profile.destroy
      render(:action => :new)
    end
  end

  def upload_avatar
    Google_analytics.new.userActions("MyProfile","UploadAvatar")
    render :layout => false
  end

  def crop_avatar
    render :layout => false
  end

  def do_crop
    # Should we crop?
    scaled_img = Magick::ImageList.new(current_user.avatar.path)
    orig_img = Magick::ImageList.new(current_user.avatar.path(:original))
    scale = orig_img.columns.to_f / scaled_img.columns

    args = [ params[:x1], params[:y1], params[:width], params[:height] ]
    args = args.collect { |a| a.to_i * scale }

    orig_img.crop!(*args)
    orig_img.write(current_user.avatar.path(:original))

    current_user.avatar.reprocess!
    current_user.save

    head :ok
  end

  def upload
    profile = current_user.profile
    profile.avatar = params[:user][:avatar]
    profile.save
    current_user.save

    redirect_to crop_avatar_path
  end

  def update
    @user = current_user
    @profile = Profile.find(params[:id])

    # params misc_info is when skills certifications languages specialties associations
    # are being edited
    if params[:misc_info].present?
      order = 1
      %w{ skills certifications languages specialties associations }.each do |attrs|
        sel = eval("params[:profile][:profile_#{attrs}_attributes]") || []
        sel.each do |k,attr|
          if not attr[:name].empty?
            attr[:order] = order
            attr[:profile_id] = @profile.id
            order = order + 1
          end
        end
      end

      if params[:user]
        if params[:user][:gender].present?
          @user.gender = params[:user][:gender]
          @user.save!
        end
      end

    else
      # the first row of the profile card has location info
      if params[:location].present?
        if params[:location][:city].present?
          @profile.location.city = params[:location][:city]
        end
        if params[:location][:zip_code].present?
          @profile.location.zip_code = params[:location][:zip_code]
        end
        if params[:location][:country].present?
          @profile.location.country = Country.find(params[:location][:country])
        end
        @profile.location.save!
      end

      # now come position changes
      if params[:position].present?
        if @profile.positions.default.first.present?
          @position = @profile.positions.default.first
          if params[:position][:size].present?
            @position.company_size = CompanySize.find(params[:position][:size])
          end
          if params[:position][:level].present?
            @position.job_level = JobLevel.find(params[:position][:level])
          end
          @position.save

          # if user is trying to update title on the page
          if params[:position][:title].present?
            @profile.positions.each do |p|
              if p.id.eql?params[:position][:title].to_i
                p.is_default = 1
              else
                p.is_default = 0
              end
              p.save
            end
          end

        end
      end

      # now comes a users email and login
      if params[:user].present?
        if params[:user][:email].present?
          if @profile.email_available?(params[:user][:email])
            @user.email = params[:user][:email]
          else
            @profile_update_error = "Email already in use. Please select another"
          end
        end
        if params[:user][:login].present?
          if @profile.login_available?(params[:user][:login])
            @user.login = params[:user][:login]
          else
            @profile_update_error = "Login already in use. Please select another"
          end
        end
        @user.save!
      end

      if params[:education].present?
        educations = Education.where(:profile_id => @profile.id)
        educations.each do |e|
          if e.id.eql?params[:education][:id].to_i
            e.is_default = 1
          else
            e.is_default = 0
          end
          e.save
        end
      end

    end

    @profile.update_attributes(params[:profile])

    # render whatever partial was updated but first source profile data once more in case something
    # was updated (in case something was deleted, it should not appear in the view)
    #@profile = current_user.profile
    @profile = Profile.find(params[:id])

    if params[:misc_info].present?
      # if it's tips then i need to also source the tips again
      if params[:misc_info].eql?"tips"
        @tip = ProfileTip.find(:all, :conditions => ["profile_id = ? and profile_tip_type = ?", @profile.id, "tip"]).first
        @book = ProfileTip.find(:all, :conditions => ["profile_id = ? and profile_tip_type = ?", @profile.id, "business_book"]).first
        @quote = ProfileTip.find(:all, :conditions => ["profile_id = ? and profile_tip_type = ?", @profile.id, "business_quote"]).first
        @website = ProfileTip.find(:all, :conditions => ["profile_id = ? and profile_tip_type = ?", @profile.id, "website"]).first
      end
      render :partial => "profile_#{params[:misc_info]}"

    elsif params[:profile_tab_info].present?
      render :partial => "profile_#{params[:profile_tab_info]}"

    else
      # if validation failed, show the edit partial again
      if @profile_update_error.present?
        render :partial => "profile_card_" + params[:profile_card] + "_edit"
      # don't show anything if editing status
      elsif params[:profile_card].eql?"status"
        render :nothing => true
      # show the view partial, not the edit
      else
        render :partial => "profile_card_" + params[:profile_card]
      end
    end
  end
end
