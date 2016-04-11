angular
  .module 'angular.viacep', []

angular
  .module('angular.viacep')
  .factory 'viaCEP', [
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

angular
  .module 'angular.viacep'
  .directive 'viaCep', [
    'viaCEPHelper'
    (viaCEPHelper) ->
      restrict: 'A'
      require: 'ngModel'
      scope:
        viacepKey: '@viaCep'
      link: (scope, element, attrs, ngModelController) ->

        _get = (cepValue) ->
          if viaCEPHelper.isValidCep(cepValue)
            viaCEPHelper.get(cepValue).then(() ->
              ngModelController.$setValidity('cep', true)
            ,() ->
              ngModelController.$setValidity('cep', false)
            )

        if scope.viacepKey == 'cep'
          scope.$watch(() ->
            ngModelController.$modelValue
          ,(cepValue) ->
            _get(cepValue)
          )
        else
          viaCEPHelper.registerMapper(scope.viacepKey, ngModelController)
  ]

angular
  .module 'angular.viacep'
  .factory 'viaCEPHelper', [
    'viaCEP'
    '$q'
    (viaCEP, $q) ->
      service = {}
      _mappers = {}
      _validKeys = [
        'cep'
        'logradouro'
        'complemento'
        'bairro'
        'localidade'
        'uf'
        'unidade'
        'ibge'
        'gia'
      ]

      _registerMapper = (viacepKey, modelController) ->
        throw new TypeError "viacep key must be one of: #{_validKeys}" if not _isValidKey(viacepKey)
        _mappers[viacepKey] = modelController

      _fillAddress = (address) ->
        for key in _validKeys
          if _mappers[key] != undefined
            _mappers[key].$setViewValue(address[key])
            # _mappers[key].$commitViewValue()
            _mappers[key].$render()

      _cleanAddress = (address) ->
        for key in _validKeys
          if _mappers[key] != undefined
            _mappers[key].$setViewValue('')
            _mappers[key].$render()

      _get = (cepValue) ->
        deferred = $q.defer()
        viaCEP.get(cepValue)
        .then (response) ->
          deferred.resolve()
          _fillAddress(response)
        , (response) ->
          deferred.reject()
          _cleanAddress()
        deferred.promise

      _isValidKey = (viacepKey) ->
        index = _validKeys.indexOf(viacepKey)
        if index == -1
          return false
        true

      _isValidCep = (cepValue) ->
        return false if cepValue is '' or cepValue is null or cepValue is undefined
        formatedCep = cepValue.replace(/\D/g, '')
        return false if formatedCep.length != 8
        true

      service.registerMapper = _registerMapper
      service.fillAddress = _fillAddress
      service.get = _get
      service.isValidCep = _isValidCep

      service
  ]