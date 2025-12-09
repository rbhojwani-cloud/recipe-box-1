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

    # build a new recipe instance for the form on the index page
    @recipe = current_user.recipes.new

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
    # build the recipe off the current_user association
    @recipe = current_user.recipes.new(recipe_params)

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

  private

  def recipe_params
    params.require(:recipe).permit(
      :title,
      :description,
      :cook_time_minutes,
      :difficulty,
      :rating,
      :favorite,      
      tag_ids: []     
    )
  end
end
