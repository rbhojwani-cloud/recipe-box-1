class RecipesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @recipes = current_user.recipes.order(created_at: :desc)

    if params["q"].present?
      search = params["q"].downcase

      @recipes = @recipes.select do |recipe|
        recipe.title.to_s.downcase.include?(search) ||
        recipe.description.to_s.downcase.include?(search)
      end
    end

    if params["difficulty"].present?
      chosen_difficulty = params["difficulty"]

      @recipes = @recipes.select do |recipe|
        recipe.difficulty == chosen_difficulty
      end
    end

    if params["favorites"] == "1"
      @recipes = @recipes.select do |recipe|
        recipe.favorite == true
      end
    end

    render template: "recipe_templates/index"
  end

  def show
    the_id = params.fetch("path_id")
    @recipe = current_user.recipes.where({ id: the_id }).at(0)

    if @recipe.nil?
      redirect_to("/recipes", alert: "Recipe not found.") and return
    end

    render template: "recipe_templates/show"
  end

  def create
    @recipe = Recipe.new
    @recipe.user_id = current_user.id

    form_data = params.fetch("recipe")
    @recipe.title             = form_data.fetch("title")
    @recipe.description       = form_data.fetch("description", nil)
    @recipe.cook_time_minutes = form_data.fetch("cook_time_minutes", nil)
    @recipe.difficulty        = form_data.fetch("difficulty", nil)
    @recipe.rating            = form_data.fetch("rating", nil)
    @recipe.favorite          = form_data.fetch("favorite", "0") == "1"

    if form_data.key?("tag_ids")
      @recipe.tag_ids = form_data.fetch("tag_ids").reject(&:blank?)
    end

    if @recipe.save
      redirect_to("/recipes/#{@recipe.id}", notice: "Recipe was successfully created.")
    else
      # reload list for index page and re-render that template
      @recipes = current_user.recipes.order(created_at: :desc)
      render template: "recipe_templates/index"
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @recipe = current_user.recipes.where({ id: the_id }).at(0)

    if @recipe.nil?
      redirect_to("/recipes", alert: "Recipe not found.") and return
    end

    @recipe.destroy
    redirect_to("/recipes", notice: "Recipe was successfully deleted.")
  end
end
