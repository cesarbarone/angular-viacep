'use strict'

describe 'angular-viacep::viacep', ->

  beforeEach ->
    module 'angular.viacep'

  beforeEach inject (_$httpBackend_) ->
    @httpBackend = _$httpBackend_
    @httpBackend.whenGET('https://viacep.com.br/ws/88054600/json/').respond({cep: '88054600', logradouro: 'Beira Mar'})

  beforeEach inject (_$compile_, _$rootScope_) ->
    @compile = _$compile_
    @scope = _$rootScope_
    @scope.address = {}
    @element = @compile('<div via-cep-form><input ng-model="address.zipcode" via-cep="cep"><input ng-model="address.address" via-cep="logradouro"></div>')(@scope)
    @scope.$digest()

  it 'should fill address', ->
    ctrl = @element.find('input').controller('ngModel')
    ctrl.$setViewValue('88054600')
    @httpBackend.flush()
    expect(@scope.address.address).toEqual 'Beira Mar'

  it 'should fill address', ->
    ctrl = @element.find('input').controller('ngModel')
    ctrl.$setViewValue('88054600')
    @httpBackend.flush()
    expect(@scope.address.address).toEqual 'Beira Mar'
    ctrl.$setViewValue('')
    @scope.$digest()
    expect(@scope.address.address).toEqual ''
