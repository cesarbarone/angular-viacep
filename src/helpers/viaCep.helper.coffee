
angular
  .module 'angular.viacep'
  .factory 'viaCepHelper', [
    'viaCep'
    '$q'
    'VALID_KEYS'
    (viaCep, $q) ->
      service = {}
      # _mappers = {}
      # VALID_KEYS = [
      #   'cep'
      #   'logradouro'
      #   'complemento'
      #   'bairro'
      #   'localidade'
      #   'uf'
      #   'unidade'
      #   'ibge'
      #   'gia'
      # ]

      # #migrate
      # _registerMapper = (viacepKey, modelController) ->
      #   throw new TypeError "viacep key must be one of: #{VALID_KEYS}" if not _isValidKey(viacepKey)
      #   _mappers[viacepKey] = modelController

      _fillAddress = (address) ->
        for key in VALID_KEYS
          if _mappers[key] != undefined
            _mappers[key].$setViewValue(address[key])
            # _mappers[key].$commitViewValue()
            _mappers[key].$render()

      _cleanAddress = (address) ->
        for key in VALID_KEYS
          if _mappers[key] != undefined
            _mappers[key].$setViewValue('')
            _mappers[key].$render()

      _get = (cepValue) ->
        deferred = $q.defer()
        viaCep.get(cepValue)
        .then (response) ->
          deferred.resolve()
          _fillAddress(response)
        , (response) ->
          deferred.reject()
          _cleanAddress()
        deferred.promise

      _isValidKey = (viacepKey) ->
        index = VALID_KEYS.indexOf(viacepKey)
        if index == -1
          return false
        true

      _isValidCep = (cepValue) ->
        return false if cepValue is '' or cepValue is null or cepValue is undefined
        formatedCep = cepValue.replace(/\D/g, '')
        return false if formatedCep.length != 8
        true

      service.fillAddress    = _fillAddress
      service.get            = _get
      service.isValidCep     = _isValidCep
      service.isValidKey     = _isValidKey

      service
  ]