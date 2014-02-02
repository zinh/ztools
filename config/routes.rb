ZinhTool::Application.routes.draw do
  controller :mangafox do
    get '/mangafox/chapter' => :chapter, as: 'mangafox_chapter'
    get '/mangafox/chapter1' => :chapter1, as: 'mangafox_chapter1'
  end
end
