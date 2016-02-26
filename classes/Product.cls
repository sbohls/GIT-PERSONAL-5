public interface Product {
  /** 
//    Any class that implements this interface must have methods with the following signatures
  **/
	Decimal getDiscount();
	Decimal getPrice();
	String getName();
 }