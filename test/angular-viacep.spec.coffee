'use strict'
describe 'angular-viacep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject ( _cep_, _$http_) ->
    @cep = _cep_
    @http = _$http_

  describe 'for invalid CEP', ->

    it 'throw error for empty cep', ->
      f = () =>
        @cep()
      expect(f).toThrowError("CEP can't be undefined")

    it 'throw error for empty cep', ->
      f = () =>
        @cep('')
      expect(f).toThrowError("CEP can't be empty")

    it 'throw error for null cep', ->
      f = () =>
        @cep(null)
      expect(f).toThrowError("CEP can't be null")

  describe 'for valid CEP', ->

    beforeEach ->
      spyOn(@http, 'get')
      @formatedCep = '89160000'
      @url = "//viacep.com.br/ws/#{@formatedCep}/json/"

    it 'calls $http get method for non formated cep', ->
      @cep('89160-000')
      expect(@http.get).toHaveBeenCalledWith(@url)

    it 'calls $http get method for formated cep', ->
      @cep(@formatedCep)
      expect(@http.get).toHaveBeenCalledWith(@url)