import 'package:marvelapp/Models/Comics.dart';

abstract class CharactersDetailsView {
  addItems(List<Comic> comics);
  showError();
  clearList();
  showLoading();
  hideLoading();
}