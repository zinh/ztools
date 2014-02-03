ZinhTool::Application.routes.draw do
  controller :mangafox do
    get '/mangafox/chapter' => :chapter, as: 'mangafox_chapter'
    get '/mangafox/chapter1' => :chapter1, as: 'mangafox_chapter1'
    get '/mangafox/search' => :search, as: 'mangafox_search'
    post '/mangafox/search/ajax' => :search_ajax
    get '/mangafox/manga' => :manga, as: 'mangafox_manga'
  end
  root to: 'homes#index'
end
