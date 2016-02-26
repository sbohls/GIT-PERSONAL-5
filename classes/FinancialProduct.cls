public with sharing class FinancialProduct Implements Product {
	private final Decimal discountedRate = 0.45;
	private final Integer hiddenCost = 100;
	private Decimal price;

	private String name;

	// Constructor
	public FinancialProduct(String name, Decimal price) {
		this.price = price;
		this.name = name;
	}

	// Price method implemented due to contract set by interface
	public Decimal getPrice() {
		return price;
	}

	// Discount method implemented due to contract set by interface
	public Decimal getDiscount() {
		return (price + hiddenCost) * discountedRate;
	}

	// Method to retrieve product name
	public String getName() {
		return name;
	}
}