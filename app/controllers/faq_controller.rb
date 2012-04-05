class FaqController < ApplicationController

  def index
    @teams = Team.find(:all, :order => "name")
    @keywords = Keyword.all(:select => 'distinct(content)', :limit => 20)

    # if someone comes in with a direct link to a post, show it
    if params[:name] == "question"
      if !params[:id].nil?
        @questions = Question.where(:id => params[:id])
      end
    else
      @questions = Question.find(:all, :order => 'created_at DESC', :limit => 5)
    end
    @categories = Array.new
  end

  def new_answer
    @qid = params[:qid]
    if !params[:submit].nil?
      answer = params[:answer]
      Answer.create!(:content => answer, :question_id => @qid, :user => session[:idsid])
      @answers = Question.find_by_id(@qid).answers.order("created_at")
      render :partial => 'answers'
    else
      render :partial => 'answer_form'
    end
  end

  def get_categories
    @teams = Team.all
    team_id = params[:team_id]
    #@categories = Team.find_by_id(team_id, :order => "name").categories
    @categories = Category.find(:all, :conditions => ["team_id = ?", team_id], :order => "name")
    render :partial => 'categories'
  end

  def get_selections
    @category_id = params[:category_id]
    @questions = Category.find_by_id(@category_id).questions
    render :partial => 'show_results'
    #@questions = @questions.paginate(:page => params[:page], :per_page => 6)
  end

  def recent_posts
    @questions = Question.find(:all, :conditions => ["created_at > ?", 7.days.ago], :order => 'created_at DESC')
    render :partial => 'show_results'
  end

  def direct_link
    type = params[:name]
    if type.eql?"question"
      qid = params[:id]
      @questions = Question.where(:id => qid)
    end
    #render :partial => 'show_results'
    render :text => 'This feature is not yet operational. Please check back later..'
  end

  def change_parent
    team_id = params[:team_id]
    @category_id = params[:category_id]
    qid = params[:qid]
    question = Question.find(qid)
    question.update_attribute(:category_id, @category_id)
    @questions = Category.find_by_id(@category_id).questions
    render :partial => 'show_results'
    #@questions = @questions.paginate(:page => params[:page], :per_page => 6)
  end

  def get_answer
    @qid = params[:qid]
    @answers = Question.find_by_id(@qid).answers
    render :partial => 'answers'
  end

  def post_question
    title = params[:title]
    answer = params[:content]
    team_id = params[:team_id]
    @category_id = params[:cat_id]
    category = Category.find(@category_id)

    q = Question.create!(:content => title, :user => session[:idsid], :category_id => @category_id)
    if(!answer.eql?"")
      a = Answer.create!(:content => answer, :user => session[:idsid], :question_id => q.id)
    end
    @questions = category.questions

    # send the new post email to the category owner
    Appmailer.new_post(category.owner, category.name, session[:idsid], title).deliver

    render :partial => 'show_results'
  end

  def search
    query = params[:search]
    @search = 1
    @keywords = Keyword.all(:select => 'distinct(content)', :limit => 30)
    @questions = Question.search query, :match_mode => :boolean
    if(@questions.count > 0)
      Keyword.create!(:content => query)
    end

    #@search = Question.search do
    #  fulltext query
    #end
    #@questions = @search.results
    render :partial => 'show_results'
  end

  def answer_feedback
    feed = params[:feed]
    ans_id = params[:id]
    if feed.to_i == 1
      val = Answer.find_by_id(ans_id).tup
      val += 1
      Answer.find_by_id(ans_id).update_attributes(:tup => val)
    else
      val = Answer.find_by_id(ans_id).tdown
      val += 1
      Answer.find_by_id(ans_id).update_attributes(:tdown => val)
    end
    render :nothing => true
  end

end