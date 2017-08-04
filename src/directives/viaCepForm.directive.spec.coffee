'use strict'

describe 'angular-viacep::viacep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject (_$compile_, _$rootScope_) ->
    @compile = _$compile_
    @scope = _$rootScope_
    @scope.address = {}
    @element = @compile('<div via-cep-form></div>')(@scope)
    @scope.$digest()

  beforeEach inject (_viaCepHelper_) ->
    @helper = _viaCepHelper_
    @ctrl = @element.controller('viaCepForm')

  it 'should attach empty mappers', ->
    expect(@ctrl.mappers).toEqual []

  it 'should call viaCepHelper #isValidKey and throw error for invalid key', ->
    spyOn(@helper, 'isValidKey')
    expect(() =>
     @ctrl.registerMapper('invalidKey', {})
    ).toThrow(new Error("viacep key must be one of: cep,logradouro,complemento,bairro,localidade,uf,unidade,ibge,gia"));

  it 'should call viaCepHelper #isValidKey', ->
    mapper = {mapper: 'm'}
    @ctrl.registerMapper('logradouro', mapper)
    expect(@ctrl.mappers['logradouro']).toBe(mapper)

  describe "#get", ->

    it 'should call viaCepHelper#get with mappers', ->
      cep = '88054611'
      spyOn(@helper, 'get')
      @ctrl.get(cep)
      expect(@helper.get).toHaveBeenCalledWith(cep, @ctrl.mappers)

  describe "#cleanAddress", ->

    it 'should call viaCepHelper#cleanAddress with mappers', ->
      spyOn(@helper, 'cleanAddress')
      @ctrl.cleanAddress()
      expect(@helper.cleanAddress).toHaveBeenCalled()

