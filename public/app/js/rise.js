var Rise = angular.module('Rise',[]);

Rise.controller('Rise', ['$scope', '$routeParams', '$http', '$location',
function ($scope, $routeParams, $http, $location) {
  $scope.uuid = $routeParams.uuid
  $scope.active = 'basic'
  $scope.init = function () {
    $scope.load_basic()
    $scope.load_skill()
    $scope.load_t630()
  }
  $scope.load_basic = function () {
    $http.get('/api/basic', {params: {uuid: $scope.uuid}})
      .success(function(data) {
        $scope.basic = data
      })
  }
  $scope.load_skill = function () {
    $http.get('/api/skill', {params: {uuid: $scope.uuid}})
      .success(function(data) {
        $scope.skill = data
      })
  }
  $scope.load_t630 = function () {
    $http.get('/api/t630', {params: {uuid: $scope.uuid}})
      .success(function(data) {
        $scope.t630 = data
      })
  }
  $scope.clear = function () {
    localStorage.removeItem('uuid')
  }
  $scope.init()
}])
