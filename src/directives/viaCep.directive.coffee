angular
  .module 'angular.viacep'
  .directive 'viaCep', [
    'viaCepHelper'
    (viaCepHelper) ->
      restrict: 'A'
      require: 'ngModel'
      scope:
        viacepKey: '@viaCep'
      link: (scope, element, attrs, ngModelController) ->
        _get = (cepValue) ->
          if viaCepHelper.isValidCep(cepValue)
            viaCepHelper.get(cepValue).then(() ->
              ngModelController.$setValidity('cep', true)
            ,() ->
              ngModelController.$setValidity('cep', false)
            )
        if scope.viacepKey == 'cep'
          scope.$watch(() ->
            ngModelController.$modelValue
          ,(cepValue) ->
            _get(cepValue)
          )
        else
          viaCepHelper.registerMapper(scope.viacepKey, ngModelController)
  ]