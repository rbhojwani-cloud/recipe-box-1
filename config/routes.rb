Rails.application.routes.draw do
  devise_for :users
  
  root to: "recipes#index"

  post("/insert_recipe", { :controller => "recipes", :action => "create" })
  get("/recipes", { :controller => "recipes", :action => "index" })
  get("/recipes/:path_id", { :controller => "recipes", :action => "show" })
  post("/modify_recipe/:path_id", { :controller => "recipes", :action => "update" })
  get("/delete_recipe/:path_id", { :controller => "recipes", :action => "destroy" })

  post("/insert_ingredient/:recipe_id", { :controller => "ingredients", :action => "create" })
  post("/modify_ingredient/:recipe_id/:path_id", { :controller => "ingredients", :action => "update" })
  get("/delete_ingredient/:recipe_id/:path_id", { :controller => "ingredients", :action => "destroy" })

  post("/insert_tag", { :controller => "tags", :action => "create" })
  get("/tags", { :controller => "tags", :action => "index" })
  post("/modify_tag/:path_id", { :controller => "tags", :action => "update" })
  get("/delete_tag/:path_id", { :controller => "tags", :action => "destroy" })

  post("/update_recipe_favorite/:path_id", { :controller => "recipes", :action => "update_favorite" })
end
