angular.module('angular.viacep', []);

angular.module('angular.viacep').factory('cep', [
  '$http', function($http) {
    var _get;
    _get = function(cepValue) {
      var formatedCep, viaCepUrl;
      if (cepValue === void 0) {
        throw new TypeError("CEP can't be undefined");
      }
      if (cepValue === '') {
        throw new TypeError("CEP can't be empty");
      }
      if (cepValue === null) {
        throw new TypeError("CEP can't be null");
      }
      formatedCep = cepValue.replace(/\D/g, '');
      viaCepUrl = "//viacep.com.br/ws/" + formatedCep + "/json/";
      return $http.get(viaCepUrl);
    };
    return {
      get: _get
    };
  }
]);

angular.module('angular.viacep').directive('viacep', [
  'cep', 'viacepHelper', function(cep, viacepHelper) {
    return {
      restrict: 'A',
      require: 'ngModel',
      scope: {
        viacepKey: '@viacep'
      },
      link: function(scope, element, attrs, ngModelController) {
        var _get;
        viacepHelper.registerMapper(scope.viacepKey, ngModelController);
        _get = function(cepValue) {
          return viacepHelper.get(cepValue);
        };
        if (scope.viacepKey === 'cep') {
          return scope.$watch(function() {
            return ngModelController.$modelValue;
          }, function(cepValue) {
            return _get(cepValue);
          });
        }
      }
    };
  }
]);

angular.module('angular.viacep').factory('viacepHelper', [
  'cep', function(cep) {
    var _fillAddress, _get, _isValidCep, _isValidKey, _mappers, _registerMapper, _validKeys, service;
    service = {};
    _mappers = {};
    _validKeys = ['cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf', 'unidade', 'ibge', 'gia'];
    _registerMapper = function(viacepKey, modelController) {
      if (!_isValidKey(viacepKey)) {
        throw new TypeError("viacep key must be one of: " + _validKeys);
      }
      return _mappers[viacepKey] = modelController;
    };
    _fillAddress = function(address) {
      var i, key, len, results;
      results = [];
      for (i = 0, len = _validKeys.length; i < len; i++) {
        key = _validKeys[i];
        if (_mappers[key] !== void 0) {
          _mappers[key].$setViewValue(address[key]);
          results.push(_mappers[key].$$commitViewValue());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    _get = function(cepValue) {
      if (_isValidCep(cepValue)) {
        return cep.get(cepValue).then(function(response) {
          return _fillAddress(response.data);
        });
      }
    };
    _isValidKey = function(viacepKey) {
      var index;
      index = _validKeys.indexOf(viacepKey);
      if (index === -1) {
        return false;
      }
      return true;
    };
    _isValidCep = function(cepValue) {
      var formatedCep;
      if (cepValue === '' || cepValue === null || cepValue === void 0) {
        return false;
      }
      formatedCep = cepValue.replace(/\D/g, '');
      if (formatedCep.length !== 8) {
        return false;
      }
      return true;
    };
    service.registerMapper = _registerMapper;
    service.fillAddress = _fillAddress;
    service.get = _get;
    return service;
  }
]);
