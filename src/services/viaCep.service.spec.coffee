describe 'angular-viacep::cep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject ( _viaCep_, _$http_) ->
    @viaCep = _viaCep_
    @http = _$http_

  describe 'for invalid CEP', ->

    it 'throw error for empty cep', ->
      expect(@viaCep.get).toThrowError("CEP can't be undefined")

    it 'throw error for empty cep', ->
      f = () =>
        @viaCep.get('')
      expect(f).toThrowError("CEP can't be empty")

    it 'throw error for null cep', ->
      f = () =>
        @viaCep.get(null)
      expect(f).toThrowError("CEP can't be null")

  describe 'for valid CEP', ->

    beforeEach ->
      spyOn(@http, 'get').and.callThrough()
      @formatedCep = '89160000'
      @url = "https://viacep.com.br/ws/#{@formatedCep}/json/"

    it 'calls $http get method for non formated cep', ->
      @viaCep.get('89160-000')
      expect(@http.get).toHaveBeenCalledWith(@url)

    it 'calls $http get method for formated cep', ->
      @viaCep.get(@formatedCep)
      expect(@http.get).toHaveBeenCalledWith(@url)