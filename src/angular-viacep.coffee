angular
  .module 'angular.viacep', []

angular
  .module('angular.viacep')
  .factory 'cep', [
    '$http'
    ($http) ->
      _get = (cepValue) ->
        throw new TypeError "CEP can't be undefined" if cepValue is undefined
        throw new TypeError "CEP can't be empty" if cepValue is ''
        throw new TypeError "CEP can't be null" if cepValue is null
        formatedCep = cepValue.replace(/\D/g, '')
        viaCepUrl = "//viacep.com.br/ws/#{formatedCep}/json/"
        $http.get(viaCepUrl)

      get: _get
  ]

angular
  .module 'angular.viacep'
  .directive 'viacep', [
    'cep'
    'viacepHelper'
    (cep, viacepHelper) ->
      restrict: 'A'
      require: 'ngModel'
      scope:
        viacepKey: '@viacep'
      link: (scope, element, attrs, ngModelController) ->
        viacepHelper.registerMapper(scope.viacepKey, ngModelController)

        _get = (cepValue) ->
          viacepHelper.get(cepValue)

        if scope.viacepKey == 'cep'
          scope.$watch(() ->
            ngModelController.$modelValue
          ,(cepValue) ->
            _get(cepValue)
          )
  ]

angular
  .module 'angular.viacep'
  .factory 'viacepHelper', [
    'cep'
    (cep) ->
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
          _mappers[key].$setViewValue(address[key]) if _mappers[key] != undefined

      _get = (cepValue) ->
        if _isValidCep(cepValue)
          cep.get(cepValue)
          .then (response) ->
            _fillAddress(response.data)

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

      service
  ]