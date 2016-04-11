angular.module('angular.viacep', []);

angular.module('angular.viacep').factory('viaCEP', [
  '$http', '$q', function($http, $q) {
    var _get;
    _get = function(cepValue) {
      var deferred, formatedCep, viaCepUrl;
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
      viaCepUrl = "https://viacep.com.br/ws/" + formatedCep + "/json/";
      deferred = $q.defer();
      $http.get(viaCepUrl).then(function(response) {
        var raw;
        raw = response.data;
        if (raw.erro) {
          return deferred.reject('CEP not found');
        } else {
          return deferred.resolve(raw);
        }
      });
      return deferred.promise;
    };
    return {
      get: _get
    };
  }
]);

angular.module('angular.viacep').directive('viaCep', [
  'viaCEPHelper', function(viaCEPHelper) {
    return {
      restrict: 'A',
      require: 'ngModel',
      scope: {
        viacepKey: '@viaCep'
      },
      link: function(scope, element, attrs, ngModelController) {
        var _get;
        _get = function(cepValue) {
          if (viaCEPHelper.isValidCep(cepValue)) {
            return viaCEPHelper.get(cepValue).then(function() {
              return ngModelController.$setValidity('cep', true);
            }, function() {
              return ngModelController.$setValidity('cep', false);
            });
          }
        };
        if (scope.viacepKey === 'cep') {
          return scope.$watch(function() {
            return ngModelController.$modelValue;
          }, function(cepValue) {
            return _get(cepValue);
          });
        } else {
          return viaCEPHelper.registerMapper(scope.viacepKey, ngModelController);
        }
      }
    };
  }
]);

angular.module('angular.viacep').factory('viaCEPHelper', [
  'viaCEP', '$q', function(viaCEP, $q) {
    var _cleanAddress, _fillAddress, _get, _isValidCep, _isValidKey, _mappers, _registerMapper, _validKeys, service;
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
          results.push(_mappers[key].$render());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    _cleanAddress = function(address) {
      var i, key, len, results;
      results = [];
      for (i = 0, len = _validKeys.length; i < len; i++) {
        key = _validKeys[i];
        if (_mappers[key] !== void 0) {
          _mappers[key].$setViewValue('');
          results.push(_mappers[key].$render());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    _get = function(cepValue) {
      var deferred;
      deferred = $q.defer();
      viaCEP.get(cepValue).then(function(response) {
        deferred.resolve();
        return _fillAddress(response);
      }, function(response) {
        deferred.reject();
        return _cleanAddress();
      });
      return deferred.promise;
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
    service.isValidCep = _isValidCep;
    return service;
  }
]);
