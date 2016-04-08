angular
  .module 'angular.viacep', []

angular
  .module('angular.viacep')
  .service 'cep', [
    '$http'
    ($http) ->
      (cep) ->
        throw new TypeError "CEP can't be undefined" if cep is undefined
        throw new TypeError "CEP can't be empty" if cep is ''
        throw new TypeError "CEP can't be null" if cep is null
        formatedCep = cep.replace(/\D/g, '')
        viaCepUrl = "//viacep.com.br/ws/#{formatedCep}/json/"
        $http.get(viaCepUrl)
  ]