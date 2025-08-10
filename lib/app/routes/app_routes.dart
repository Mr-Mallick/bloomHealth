part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  
  static const HOME = _Paths.HOME;
  static const FERTILITY = _Paths.FERTILITY;
  static const FERTILITY_SETUP = _Paths.FERTILITY_SETUP;
  static const FLUID = _Paths.FLUID;
  static const FLUID_SETUP = _Paths.FLUID_SETUP;
  static const MEDICINE = _Paths.MEDICINE;
  static const ADD_MEDICINE = _Paths.ADD_MEDICINE;
}

abstract class _Paths {
  _Paths._();
  
  static const HOME = '/home';
  static const FERTILITY = '/fertility';
  static const FERTILITY_SETUP = '/fertility-setup';
  static const FLUID = '/fluid';
  static const FLUID_SETUP = '/fluid-setup';
  static const MEDICINE = '/medicine';
  static const ADD_MEDICINE = '/add-medicine';
}