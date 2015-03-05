var Rise = angular.module('Rise',[]);

$(function() {
    $("body").tooltip({ selector: '[data-toggle=tooltip]' });
});

Rise.controller('Rise', ['$scope', '$routeParams', '$http', '$location',
function ($scope, $routeParams, $http, $location) {
  $scope.uuid = $routeParams.uuid
  $scope.active = 'basic'
  $scope.cov = {}
  $scope.ilvl = 630
  $scope.init = function () {
    $scope.load_basic()
    $scope.load_skill()
    $scope.load_rare()
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
  $scope.load_rare = function () {
    $http.get('/api/rare', {params: {uuid: $scope.uuid}})
      .success(function(data) {
        $scope.rare = data
      })
  }
  $scope.clear = function () {
    localStorage.removeItem('uuid')
  }
  $scope.init()
}])
