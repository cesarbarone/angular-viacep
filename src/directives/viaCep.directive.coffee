angular
  .module 'angular.viacep'
  .directive 'viaCep', [
    'viaCepHelper'
    (viaCepHelper) ->
      restrict: 'A'
      require: ['ngModel', '^viaCepForm']
      scope:
        viacepKey: '@viaCep'
      link: (scope, element, attrs, controllers) ->
        ngModelController = controllers[0]
        addressController = controllers[1]

        _get = (cepValue) ->
          if viaCepHelper.isValidCep(cepValue)
            addressController.get(cepValue).then(() ->
              ngModelController.$setValidity('cep', true)
            ,() ->
              ngModelController.$setValidity('cep', false)
            )
          else
            addressController.cleanAddress()


        if scope.viacepKey == 'cep'
          scope.$watch(() ->
            ngModelController.$modelValue
          ,(cepValue) ->
            _get(cepValue)
          )
        else
          addressController.registerMapper(scope.viacepKey, ngModelController)
  ]