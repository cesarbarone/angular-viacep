'use strict'
describe 'angular-viacep::cep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject ( _viaCEP_, _$http_) ->
    @viaCEP = _viaCEP_
    @http = _$http_

  describe 'for invalid CEP', ->

    it 'throw error for empty cep', ->
      expect(@viaCEP.get).toThrowError("CEP can't be undefined")

    it 'throw error for empty cep', ->
      f = () =>
        @viaCEP.get('')
      expect(f).toThrowError("CEP can't be empty")

    it 'throw error for null cep', ->
      f = () =>
        @viaCEP.get(null)
      expect(f).toThrowError("CEP can't be null")

  describe 'for valid CEP', ->

    beforeEach ->
      spyOn(@http, 'get').and.callThrough()
      @formatedCep = '89160000'
      @url = "https://viacep.com.br/ws/#{@formatedCep}/json/"

    it 'calls $http get method for non formated cep', ->
      @viaCEP.get('89160-000')
      expect(@http.get).toHaveBeenCalledWith(@url)

    it 'calls $http get method for formated cep', ->
      @viaCEP.get(@formatedCep)
      expect(@http.get).toHaveBeenCalledWith(@url)

describe 'angular-viacep:viaCEPHelper', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject (_viaCEPHelper_, _viaCEP_, _$httpBackend_) ->
    @viaCEPHelper = _viaCEPHelper_
    @viaCEP = _viaCEP_
    @httpBackend = _$httpBackend_

  describe '#isValidCep', ->

    it 'should not call #get from cep for empty value', ->
      valid = @viaCEPHelper.isValidCep('')
      expect(valid).toEqual false

    it 'should not call #get from cep for null value', ->
      valid = @viaCEPHelper.isValidCep(null)
      expect(valid).toEqual false

    it 'should not call #get from cep for undefined value', ->
      valid = @viaCEPHelper.isValidCep(undefined)
      expect(valid).toEqual false

    it 'should not call #get from cep for invalid cep', ->
      invalidCep = '993'
      valid = @viaCEPHelper.isValidCep(invalidCep)
      expect(valid).toEqual false

    it 'should call #get from cep for valid cep', ->
      validCep = '08465312'
      valid = @viaCEPHelper.isValidCep(validCep)
      # expect(valid).toEqual false

  describe '#get', ->

    beforeEach ->
      spyOn(@viaCEP, 'get').and.callThrough()

    it 'should call #get from cep for valid cep', ->
      validCep = '08465312'
      @viaCEPHelper.get(validCep)
      expect(@viaCEP.get).toHaveBeenCalledWith(validCep)

  xdescribe '#get promise', ->

    beforeEach ->
      @cep = '99999999'

    it 'should reject', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        erro: true
      @httpBackend.whenGET(url).respond(response)
      promise = @viaCEPHelper.get(@cep)
      spyOn(promise, 'reject')
      @httpBackend.flush()
      expect(promise.reject).toHaveBeenCalled()

    it 'should resolve', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        cep: @cep
      @httpBackend.whenGET(url).respond(response)
      promise = @viaCEPHelper.get(@cep)
      spyOn(promise, 'resolve')
      @httpBackend.flush()

  describe '#registerMapper', ->

    beforeEach ->
      @ngModelController = () ->

    it 'should throw error for invalid key', ->
      invalidKey = 'invalidKey'
      fn = () =>
        @viaCEPHelper.registerMapper(invalidKey, @ngModelController)
      expect(fn).toThrowError("viacep key must be one of: cep,logradouro,complemento,bairro,localidade,uf,unidade,ibge,gia")

    it 'should not throw error valid keys', ->
      for key in ['cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf', 'unidade', 'ibge', 'gia']
        fn = () =>
          @viaCEPHelper.registerMapper(key, @ngModelController)
        expect(fn).not.toThrowError()

  describe '#fillAddress', ->

    beforeEach ->
      @address =
        "cep": "01001-000"
        "logradouro": "Praça da Sé"
        "complemento": "lado ímpar"
        "bairro": "Sé"
        "localidade": "São Paulo"
        "uf": "SP"
        "unidade": "1"
        "ibge": "3550308"
        "gia": "1004"

    it 'should smoke', ->
      keys = ['cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf', 'unidade', 'ibge', 'gia']
      for key in keys
        ngModelController =
          $setViewValue: ->
            return null
          $render: ->
            return null

        spyOn(ngModelController, '$setViewValue')
        spyOn(ngModelController, '$render')
        @viaCEPHelper.registerMapper(key, ngModelController)
        @viaCEPHelper.fillAddress(@address)
        expect(ngModelController.$setViewValue).toHaveBeenCalledWith(@address[key])
        expect(ngModelController.$render).toHaveBeenCalled()
