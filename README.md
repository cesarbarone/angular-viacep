# angular-viacep  &nbsp;[![Build Status](https://travis-ci.org/cesarbarone/angular-viacep.png?branch=master)](https://travis-ci.org/cesarbarone/angular-viacep)

# ViaCEP AngularJS directive and service

## See demo [here](https://plnkr.co/edit/he6Kvp?p=info)

## How to install:

### Install from bower
    bower install angular-viacep --save

### Include this line in your index.html
    <script src="bower_components/angular-viacep/dist/angular-viacep.min.js"></script>

### How to use directive(recommended)
#### Just see [demo](https://plnkr.co/edit/he6Kvp?p=info)

### Or, if you prefer, use only service
    angular.module('app', ['angular.viacep'])
    angular.module('app').controller('ctrl', function ctrl($scope, viaCEP) {
        viaCEP.get('08465-312').then(function(response){
            $scope.address = response
        });
    });
