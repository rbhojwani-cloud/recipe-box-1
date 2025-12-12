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
    @recipe = current_user.recipes.new(recipe_params)

    if @recipe.save
      redirect_to("/recipes", notice: "Recipe was successfully created.")
    else
      
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

  def update_favorite
    the_id = params.fetch("path_id")
    @recipe = current_user.recipes.where(id: the_id).at(0)

    if @recipe.nil?
      redirect_to("/recipes", alert: "Recipe not found.") and return
    end

    new_value = params.fetch("favorite", "0") == "1"

    @recipe.update_column(:favorite, new_value)

    if params["from_favorites"] == "1"
      redirect_to("/recipes?favorites=1", notice: "Favorite status updated.")
    else
      redirect_to("/recipes", notice: "Favorite status updated.")
    end
  end

  private

  def recipe_params
  params.require(:recipe).permit(
    :title,
    :description,
    :instructions,          
    :cook_time_minutes,
    :difficulty,
    :rating,
    :favorite,
    tag_ids: []
  )
  end
end
