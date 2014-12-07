var Cocoa = angular.module('Cocoa',[]);

Cocoa.controller('Cocoa', ['$scope', '$routeParams', '$http', '$location',
function ($scope, $routeParams, $http, $location) {
  if(typeof(Storage) !== "undefined") {
    uuid = localStorage.uuid
    if(uuid) {
      $location.url('/' + uuid)
      return
    }
  }
  $scope.content = ''
  $scope.upload = function () {
    $http.post('/api/upload', {content: $scope.content})
      .success(function(data) {
        localStorage.uuid = data
        $location.url('/' + data)
      })
  }
}])
