angular
  .module 'angular.viacep'
  .directive 'viaCepForm', [
    () ->
      restrict: 'A'
      controller: [
        '$scope'
        'viaCepHelper'
        'VALID_KEYS'
        ($scope, viaCepHelper, VALID_KEYS) ->
          @.mappers = []

          _get = (cep) ->
            viaCepHelper.get(cep, @.mappers)

          _isValidKey = (viacepKey) ->
            index = VALID_KEYS.indexOf(viacepKey)
            if index == -1
              return false
            true

          _registerMapper = (viacepKey, modelController) ->
            validKey = _isValidKey(viacepKey)
            throw new TypeError "viacep key must be one of: #{VALID_KEYS}" if not validKey
            @.mappers[viacepKey] = modelController

          @.registerMapper = _registerMapper
          @.get            = _get

          return @
      ]

      link: (scope, element, attrs) ->
  ]


angular
  .module 'angular.viacep'
  .value 'VALID_KEYS', [
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
