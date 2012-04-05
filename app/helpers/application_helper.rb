module ApplicationHelper

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  # Return a title on a per-page basis.
  def title
    base_title = "DA iTeam Abode"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end

  def get_owner(user)
    if !user.nil?
      user
    else
      session[:idsid]
    end
  end

  def get_email_from_idsid(user)
    email = `cdislookup -i #{user} | grep DomainAddress | awk '{print $3}'`
    if email.present?
      email = email.chomp
      #session[:email] = email
    end

    return email
  end

  def get_first_name(user)
    me = 0

    # avoiding multiple cdislookup calls by storing the current users first name into a session
    if session[:fname].present?
      if user.eql?session[:idsid]
        me = 1
        return session[:fname]
      end
    end

    name = ""
    nname = `cdislookup -i #{user} | grep Nickname | awk '{print $3}'`
    if nname.blank?
      fname = `cdislookup -i #{user} | grep Fname | awk '{print $3}'`
      name = fname.humanize
    else
      name = nname.humanize
    end
    unless name == ""
      if me
        session[:fname] = name
      end
      return name
    end
    return session[:idsid]
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

  def get_human_time(date)
    return date.strftime "%D, %H:%M %p"
  end

  def store_prev_sel (sel_category)
      session[:prev_sel_category] = sel_category
  end

  def line_break(string)
      string.gsub("\n", '<br/>')
  end

  def snippet(text, wordcount)
    text.split[0..(wordcount-1)].join(" ") +(text.split.size > wordcount ? "..." : "")
  end


    def get_email_name(user)
    name = ""
    nname = `cdislookup -i #{user} | grep Nickname | awk '{print $3}'`
    if nname.blank?
      fname = `cdislookup -i #{user} | grep Fname | awk '{print $3}'`
      name = fname.humanize
    else
      name = nname.humanize
    end
    unless name == ""
      name = name.chomp
      return name
    end
    end

end
