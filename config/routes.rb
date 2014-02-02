ZinhTool::Application.routes.draw do
  controller :mangafox do
    get '/mangafox/chapter' => :chapter, as: 'mangafox_chapter'
  end
end
