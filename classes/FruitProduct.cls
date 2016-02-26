public with sharing class FruitProduct implements Product {
	private final Decimal discountedRate = 0.85;

	private Decimal price;

	private String name;

	// Constructor
	public FruitProduct(String name, Decimal price) {
		this.price = price;
		this.name = name;
	}

	// Price method implemented due to contract set by interface
	public Decimal getPrice() {
		return price;
	} 

	// Discount method implemented due to contract set by interface
	public Decimal getDiscount() {
		return price * discountedRate;
	} 

	// Method to retrieve product name
	public String getName() {
		return name;
	}
}