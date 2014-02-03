@MangafoxCtrl = ($scope, $http)->
  $scope.$watch('query', (newVal, oldVal)->
    if newVal.length > 3
      $http.post('/mangafox/search/ajax', {query: newVal}, headers: {'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}).
        success((data, status)->
          $scope.mangas = data
        )
  ,true
  )
