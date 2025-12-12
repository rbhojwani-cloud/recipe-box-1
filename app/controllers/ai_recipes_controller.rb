class AiRecipesController < ApplicationController
  before_action :authenticate_user!

  def new
    render template: "ai_recipe_templates/new"
  end

  def create
    prompt = params.fetch("prompt", "").to_s.strip
    difficulty = params.fetch("difficulty", "").to_s.strip

    if prompt.blank?
      redirect_to("/ai_recipes/new", alert: "Please enter ingredients or an idea.") and return
    end

    chat = AI::Chat.new

    chat.system("You are a helpful cooking assistant. Return one practical recipe a beginner can follow.")

    chat.model = "gpt-4.1-nano"

    chat.schema = {
      type: "object",
      additionalProperties: false,
      required: ["title", "description", "difficulty", "cook_time_minutes", "instructions", "tags"],
      properties: {
        title: { type: "string" },
        description: { type: "string" },
        difficulty: { type: "string", enum: ["Easy", "Medium", "Hard"] },
        cook_time_minutes: { type: "integer" },
        instructions: { type: "string" },
        tags: { type: "array", items: { type: "string" } }
      }
    }

    chat.user(<<~TEXT)
      Create ONE recipe based on: #{prompt}
      Difficulty preference: #{difficulty.presence || "Any"}

      Instructions should be step-by-step (one step per line).
      Tags should be short words/phrases like: "weeknight", "vegetarian", "pasta".
    TEXT

    response = chat.generate!
    data = response[:content]

    @recipe = current_user.recipes.new(
      title: data[:title],
      description: data[:description],
      cook_time_minutes: data[:cook_time_minutes],
      difficulty: data[:difficulty],
      instructions: data[:instructions],
      favorite: false
    )

    @suggested_tags = Array(data[:tags]).map { |t| t.to_s.strip.downcase }.reject(&:blank?)

    render template: "ai_recipe_templates/review"
  rescue => e
    redirect_to("/ai_recipes/new", alert: "AI generation failed: #{e.message}")
  end
end
