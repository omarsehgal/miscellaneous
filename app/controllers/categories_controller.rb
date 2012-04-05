require 'will_paginate/array'

class CategoriesController < ApplicationController

  def index
    @teams = Team.find(:all, :order => "name")

    if !params[:team].nil?
      team_id = params[:team][:id]
      if team_id.eql?'0'
        @categories = Category.find(:all, :order => "name")
      else
        @categories = Team.find_by_id(team_id).categories
      end
    else
      @categories = Category.find(:all, :order => "name")
    end

    @categories = @categories.paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @category = Category.find(params[:id])
    @team_name = Team.find(@category.team_id).name
    @teams = Team.all
  end

  def my_categories
    @teams = Team.find(:all, :order => "name")
    @categories = Category.find(:all, :conditions => ["owner like ?", "%#{session[:idsid]}%"])
    @categories = @categories.paginate(:page => params[:page], :per_page => 15)
    render :index
  end

  def new
    @title = "New Category"
    @teams = Team.all
    @category = Category.new
    1.times do
      question = @category.questions.build
      1.times { question.answers.build }
    end
  end

  def create
    @title = "New Category"
    @category = Category.new(params[:category])
    @teams = Team.all

    if @category.save
      redirect_to @category, :notice => "Successfully created category."
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @teams = Team.find(:all, :order => "name")
  end

  def update
    @teams = Team.all
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to @category, :notice  => "Successfully updated category."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_url, :notice => "Successfully destroyed category."
  end
end
