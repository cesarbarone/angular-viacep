describe 'angular-viacep:viaCepHelper', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject (_viaCepHelper_, _viaCep_, _$httpBackend_) ->
    @viaCepHelper = _viaCepHelper_
    @viaCep = _viaCep_
    @httpBackend = _$httpBackend_

  describe '#isValidCep', ->

    it 'should not call #get from cep for empty value', ->
      valid = @viaCepHelper.isValidCep('')
      expect(valid).toEqual false

    it 'should not call #get from cep for null value', ->
      valid = @viaCepHelper.isValidCep(null)
      expect(valid).toEqual false

    it 'should not call #get from cep for undefined value', ->
      valid = @viaCepHelper.isValidCep(undefined)
      expect(valid).toEqual false

    it 'should not call #get from cep for invalid cep', ->
      invalidCep = '993'
      valid = @viaCepHelper.isValidCep(invalidCep)
      expect(valid).toEqual false

    it 'should call #get from cep for valid cep', ->
      validCep = '08465312'
      valid = @viaCepHelper.isValidCep(validCep)
      # expect(valid).toEqual false

  describe '#get', ->

    beforeEach ->
      spyOn(@viaCep, 'get').and.callThrough()

    it 'should call #get from cep for valid cep', ->
      validCep = '08465312'
      @viaCepHelper.get(validCep)
      expect(@viaCep.get).toHaveBeenCalledWith(validCep)

    xit 'should call #fillAddress with cep and mappers', ->
      spyOn(@viaCepHelper, 'fillAddress')
      mappers = []
      validCep = '08465312'
      @viaCepHelper.get(validCep, mappers)
      expect(@viaCepHelper.fillAddress).toHaveBeenCalledWith(validCep, mappers)

  xdescribe '#get promise', ->

    beforeEach ->
      @cep = '99999999'

    it 'should reject', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        erro: true
      @httpBackend.whenGET(url).respond(response)
      promise = @viaCepHelper.get(@cep)
      spyOn(promise, 'reject')
      @httpBackend.flush()
      expect(promise.reject).toHaveBeenCalled()

    it 'should resolve', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        cep: @cep
      @httpBackend.whenGET(url).respond(response)
      promise = @viaCepHelper.get(@cep)
      spyOn(promise, 'resolve')
      @httpBackend.flush()

  describe '#fillAddress', ->

    beforeEach ->
      @address =
        "logradouro": "Praça da Sé"

    it 'should fill address', ->
      key = 'logradouro'
      ngModelController =
        $setViewValue: ->
          return null
        $render: ->
          return null
      # for key in keys
      mappers = {
        'logradouro': ngModelController
      }

      spyOn(ngModelController, '$setViewValue')
      spyOn(ngModelController, '$render')
      @viaCepHelper.fillAddress(@address, mappers)
      expect(ngModelController.$setViewValue).toHaveBeenCalledWith(@address[key])
      expect(ngModelController.$render).toHaveBeenCalled()

    it 'should not override if address already exists', ->
      key = 'logradouro'
      ngModelController =
        $setViewValue: ->
          return null
        $render: ->
          return null
        '$modelValue': 'Another logradouro'
      # for key in keys
      mappers = {
        'logradouro': ngModelController
      }

      @viaCepHelper.fillAddress(@address, mappers)
      spyOn(ngModelController, '$setViewValue')
      spyOn(ngModelController, '$render')
      @viaCepHelper.fillAddress(@address, mappers)
      expect(ngModelController.$setViewValue).not.toHaveBeenCalled()
      expect(ngModelController.$render).not.toHaveBeenCalled()

  describe '#cleanAddress', ->

    it 'should clean address', ->
      key = 'logradouro'
      ngModelController =
        $setViewValue: ->
          return null
        $render: ->
          return null
      # for key in keys
      mappers = {
        'logradouro': ngModelController
      }

      spyOn(ngModelController, '$setViewValue')
      spyOn(ngModelController, '$render')
      @viaCepHelper.cleanAddress(mappers)
      expect(ngModelController.$setViewValue).toHaveBeenCalledWith('')
      expect(ngModelController.$render).toHaveBeenCalled()
