class API
{
  static const hostConnect = "http://192.168.43.10/api_appshop";
  static const hostConnectUser = "$hostConnect/users";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostConnectItem = "$hostConnect/items";
  static const hostLaptop = "$hostConnect/laptops";
  static const hostCart = "$hostConnect/cart";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";
  static const hostImages = "$hostConnect/transactions_proof_images/";

  //signUp user
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";

  //Admin
  static const adminLogin = "$hostConnectAdmin/loginAdmin.php";
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php";

  // item
  static const uploadNewItem = "$hostConnectItem/upload.php";
  static const searchItems = "$hostConnectItem/search.php";

  //Home Laptop item
  static const getTrendingItem = "$hostLaptop/trending.php";
  static const getAllItem = "$hostLaptop/all.php";

  //Cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteToCart = "$hostCart/delete.php";
  static const updateToCart = "$hostCart/update.php";

  //favorite
  static const validateFavorite = "$hostFavorite/validate_favorite.php";
  static const addFavorite = "$hostFavorite/add.php";
  static const deleteFavorite = "$hostFavorite/delete.php";
  static const readFavorite = "$hostFavorite/read.php";

  //order
  static const addOrder = "$hostOrder/add.php";
  static const readOrders = "$hostOrder/read.php";
  static const updateStatus = "$hostOrder/update_status.php";
  static const readHistory = "$hostOrder/read_history.php";
}