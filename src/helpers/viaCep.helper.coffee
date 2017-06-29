
angular
  .module 'angular.viacep'
  .factory 'viaCepHelper', [
    'viaCep'
    '$q'
    'VALID_KEYS'
    (viaCep, $q, VALID_KEYS) ->
      service = {}

      _fillAddress = (address, mappers) ->
        for key in VALID_KEYS
          if mappers[key] != undefined
            mappers[key].$setViewValue(address[key])
            # mappers[key].$commitViewValue()
            mappers[key].$render()

      _cleanAddress = (address) ->
        for key in VALID_KEYS
          if _mappers[key] != undefined
            _mappers[key].$setViewValue('')
            _mappers[key].$render()

      _get = (cepValue, mappers) ->
        deferred = $q.defer()
        viaCep.get(cepValue)
        .then (response) ->
          deferred.resolve()
          _fillAddress(response, mappers)
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