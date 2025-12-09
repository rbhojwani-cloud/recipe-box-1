class IngredientsController < ApplicationController
  before_action :authenticate_user!

  def create
    recipe_id = params.fetch("recipe_id")
     @recipe = current_user.recipes.where({ :id => recipe_id }).at(0)

     if @recipe.nil?
      redirect_to("/recipes", :alert => "Recipe not found.") and return
    end

    @ingredient = Ingredient.new
    @ingredient.recipe_id = @recipe.id

    form_data = params.fetch("ingredient")
    @ingredient.name     = form_data.fetch("name")
    @ingredient.quantity = form_data.fetch("quantity")

    if @ingredient.save
      redirect_to("/recipes/#{@recipe.id}", :notice => "Ingredient was successfully added.")
    else
      redirect_to("/recipes/#{@recipe.id}", :alert => "Could not add ingredient. Please check the fields.")
    end
  end

  def update
    recipe_id = params.fetch("recipe_id")
    @recipe = current_user.recipes.where({ :id => recipe_id }).at(0)

    if @recipe.nil?
      redirect_to("/recipes", :alert => "Recipe not found.") and return
    end

    ingredient_id = params.fetch("path_id")
    @ingredient = @recipe.ingredients.where({ :id => ingredient_id }).at(0)

    if @ingredient.nil?
      redirect_to("/recipes/#{@recipe.id}", :alert => "Ingredient not found.") and return
    end

    form_data = params.fetch("ingredient")
    @ingredient.name     = form_data.fetch("name")
    @ingredient.quantity = form_data.fetch("quantity")

    if @ingredient.save
      redirect_to("/recipes/#{@recipe.id}", :notice => "Ingredient was successfully updated.")
    else
      redirect_to("/recipes/#{@recipe.id}", :alert => "Could not update ingredient. Please check the fields.")
    end
  end

  def destroy
    recipe_id = params.fetch("recipe_id")
    @recipe = current_user.recipes.where({ :id => recipe_id }).at(0)

    if @recipe.nil?
      redirect_to("/recipes", :alert => "Recipe not found.") and return
    end

    ingredient_id = params.fetch("path_id")
    @ingredient = @recipe.ingredients.where({ :id => ingredient_id }).at(0)

    if @ingredient.nil?
      redirect_to("/recipes/#{@recipe.id}", :alert => "Ingredient not found.") and return
    end

    @ingredient.destroy
    redirect_to("/recipes/#{@recipe.id}", :notice => "Ingredient was successfully removed.")
  end
end
