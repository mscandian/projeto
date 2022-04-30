import '../Models/Character.dart';

abstract class CharactersView {
  addItems(List<Character> characters);
  showError();
  clearList();
  showLoading();
  hideLoading();
  snackBarMessage();
}