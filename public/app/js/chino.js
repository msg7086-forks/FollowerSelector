var rabbitHouse = angular.module('rabbitHouse', [
  'ngRoute',
  'Cocoa', 'Rise'
])

rabbitHouse.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: '/app/partials/cocoa.html',
        controller: 'Cocoa'
      }).
      when('/:uuid', {
        templateUrl: '/app/partials/rise.html',
        controller: 'Rise'
      }).
      otherwise({
        redirectTo: '/'
      });
  }]);
