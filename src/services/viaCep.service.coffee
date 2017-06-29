angular
  .module('angular.viacep')
  .factory 'viaCep', [
    '$http'
    '$q'
    ($http, $q) ->
      _get = (cepValue) ->
        throw new TypeError "CEP can't be undefined" if cepValue is undefined
        throw new TypeError "CEP can't be empty" if cepValue is ''
        throw new TypeError "CEP can't be null" if cepValue is null
        formatedCep = cepValue.replace(/\D/g, '')
        viaCepUrl = "https://viacep.com.br/ws/#{formatedCep}/json/"
        deferred = $q.defer()
        $http.get(viaCepUrl)
        .then (response) ->
          raw = response.data
          if raw.erro
            deferred.reject('CEP not found')
          else
            deferred.resolve(raw)
        deferred.promise

      get: _get
  ]
