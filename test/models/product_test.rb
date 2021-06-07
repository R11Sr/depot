require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert (product.invalid?)
    assert (product.errors[:title].any?)
    assert (product.errors[:description].any?)
    assert (product.errors[:price].any?)
    assert (product.errors[:image_url].any?)
  end

  test "product price must be positive" do
      product = Product.new(title: "This new book",
              description: "Hot of the press",
              image_url: "newImage.png")

      product.price = -1
      assert product.invalid?
      assert_equal(["must be greater than or equal to 0.01"],
        product.errors[:price])

      product.price = 0
      assert product.invalid?
      assert_equal(["must be greater than or equal to 0.01"],
      product.errors[:price])

      product.price = 1
      assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "The Other new Book",
      description: "The other book is being described here",
      price: 1,
      image_url: image_url)
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
          http://a.b.c/x/y/z/fred.gif}
    bad =  %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |img|
      assert new_product(img).valid?, "#{img} shouldn't be invalid"
    end

    bad.each do |img|
      assert new_product(img).invalid?, "#{img} shouldn't be invalid"
    end

  end


  # This is the crude way

  test "Test if unique" do
    prod1 = Product.new(title: "This new book",
              description: "Hot of the press",
              image_url: "newImage.png")
    prod2 = Product.new(title: "This new book",
              description: "Hot of the press",
              image_url: "newImage.png")

    assert prod2.invalid?

  end

  test "product is not valid without a unique title" do
    product = Product.new( title: products(:ruby).title,
              description: "this i awsome",
              price: 12.99,
              image_url: "fred.gif")

    assert product.invalid?
    assert_equal(['has already been taken'], product.errors[:title])
  end

end
