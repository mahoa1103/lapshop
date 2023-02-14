import 'package:appshop/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController
{
  final RxList<Cart> _cartList = <Cart>[].obs;
  final RxList<int> _seclectItemList = <int>[].obs;
  final RxBool _isSelectAll = false.obs;
  final RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get seclectItemList => _seclectItemList.value;
  bool get isSelectAll => _isSelectAll.value;
  double get total => _total.value;

  setList(List<Cart> list)
  {
    _cartList.value = list;
  }

  addSelectItem(int selectItemCartID)
  {
    _seclectItemList.value.add(selectItemCartID);
    update();
  }

  deleteSelectItem(int selectItemCartID)
  {
    _seclectItemList.value.remove(selectItemCartID);
    update();
  }

  setIsSelectAll()
  {
                          //true
    _isSelectAll.value = !_isSelectAll.value;
  }

  clearSelectItem()
  {
    _seclectItemList.value.clear();
    update();
  }

  setTotal(double overallTotal)
  {
    _total.value = overallTotal;
  }


}