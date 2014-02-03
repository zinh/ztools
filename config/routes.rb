ZinhTool::Application.routes.draw do
  controller :mangafox do
    get '/manga/chapter' => :chapter, as: 'mangafox_chapter'
    get '/manga/chapter1' => :chapter1, as: 'mangafox_chapter1'
    get '/manga/search' => :search, as: 'mangafox_search'
    post '/manga/search/ajax' => :search_ajax
    get '/manga/title' => :manga, as: 'mangafox_manga'
  end
  root to: 'homes#index'
end
