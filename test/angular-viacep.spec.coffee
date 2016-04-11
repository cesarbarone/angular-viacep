'use strict'
describe 'angular-viacep::cep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject ( _cep_, _$http_) ->
    @cep = _cep_
    @http = _$http_

  describe 'for invalid CEP', ->

    it 'throw error for empty cep', ->
      expect(@cep.get).toThrowError("CEP can't be undefined")

    it 'throw error for empty cep', ->
      f = () =>
        @cep.get('')
      expect(f).toThrowError("CEP can't be empty")

    it 'throw error for null cep', ->
      f = () =>
        @cep.get(null)
      expect(f).toThrowError("CEP can't be null")

  describe 'for valid CEP', ->

    beforeEach ->
      spyOn(@http, 'get')
      @formatedCep = '89160000'
      @url = "https://viacep.com.br/ws/#{@formatedCep}/json/"

    it 'calls $http get method for non formated cep', ->
      @cep.get('89160-000')
      expect(@http.get).toHaveBeenCalledWith(@url)

    it 'calls $http get method for formated cep', ->
      @cep.get(@formatedCep)
      expect(@http.get).toHaveBeenCalledWith(@url)

describe 'angular-viacep:viacepHelper', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject (_viacepHelper_, _cep_, _$httpBackend_) ->
    @viacepHelper = _viacepHelper_
    @cep = _cep_
    @httpBackend = _$httpBackend_

  describe '#get', ->

    beforeEach ->
      spyOn(@cep, 'get').and.callThrough()

    it 'should not call #get from cep for empty value', ->
      @viacepHelper.get('')
      expect(@cep.get).not.toHaveBeenCalled()

    it 'should not call #get from cep for null value', ->
      @viacepHelper.get(null)
      expect(@cep.get).not.toHaveBeenCalled()

    it 'should not call #get from cep for undefined value', ->
      @viacepHelper.get(undefined)
      expect(@cep.get).not.toHaveBeenCalled()

    it 'should not call #get from cep for invalid cep', ->
      invalidCep = '993'
      @viacepHelper.get(invalidCep)
      expect(@cep.get).not.toHaveBeenCalled()

    it 'should call #get from cep for valid cep', ->
      validCep = '88040560'
      @viacepHelper.get(validCep)
      expect(@cep.get).toHaveBeenCalledWith(validCep)

  xdescribe '#get promise', ->

    beforeEach ->
      @cep = '99999999'

    it 'should reject', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        erro: true
      @httpBackend.whenGET(url).respond(response)
      promise = @viacepHelper.get(@cep)
      spyOn(promise, 'reject')
      @httpBackend.flush()
      expect(promise.reject).toHaveBeenCalled()

    it 'should resolve', ->
      url = "https://viacep.com.br/ws/#{@cep}/json/"
      response =
        cep: @cep
      @httpBackend.whenGET(url).respond(response)
      promise = @viacepHelper.get(@cep)
      spyOn(promise, 'resolve')
      @httpBackend.flush()

  describe '#registerMapper', ->

    beforeEach ->
      @ngModelController = () ->

    it 'should throw error for invalid key', ->
      invalidKey = 'invalidKey'
      fn = () =>
        @viacepHelper.registerMapper(invalidKey, @ngModelController)
      expect(fn).toThrowError("viacep key must be one of: cep,logradouro,complemento,bairro,localidade,uf,unidade,ibge,gia")

    it 'should not throw error valid keys', ->
      for key in ['cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf', 'unidade', 'ibge', 'gia']
        fn = () =>
          @viacepHelper.registerMapper(key, @ngModelController)
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
        @viacepHelper.registerMapper(key, ngModelController)
        @viacepHelper.fillAddress(@address)
        expect(ngModelController.$setViewValue).toHaveBeenCalledWith(@address[key])
        expect(ngModelController.$render).toHaveBeenCalled()
