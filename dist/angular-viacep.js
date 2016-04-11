angular.module('angular.viacep', []);

angular.module('angular.viacep').service('cep', [
  '$http', function($http) {
    return function(cep) {
      var formatedCep, viaCepUrl;
      if (cep === void 0) {
        throw new TypeError("CEP can't be undefined");
      }
      if (cep === '') {
        throw new TypeError("CEP can't be empty");
      }
      if (cep === null) {
        throw new TypeError("CEP can't be null");
      }
      formatedCep = cep.replace(/\D/g, '');
      viaCepUrl = "//viacep.com.br/ws/" + formatedCep + "/json/";
      return $http.get(viaCepUrl);
    };
  }
]);
