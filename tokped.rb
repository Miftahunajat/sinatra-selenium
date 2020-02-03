require 'selenium-webdriver'
require 'byebug'

class Tokped
  def initialize(username, password, title, description, price, qty, image, berat, ac_id)
    @username = username
    @password = password
    @title = title
    @description = description
    @price = price
    @qty = qty
    @image = image
    @berat = berat
    @ac_id = ac_id
  end

  def start
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 20) # seconds

    do_job
  end

  def find_element_by_id(id)
    @driver.find_element(:id, id)
  end

  def find_element(identifier)
    @driver.find_element(:xpath, identifier)
  end

  def fill(identifier, text)
    find_element("//input[" + identifier + "]").send_keys text
  end

  def click(identifier)
    find_element("//button[" + identifier + "]").click
  end

  def wait_click(identifier, attr = "button")
    @wait.until { find_element("//"+attr+"[" + identifier + "]").displayed? }
    @driver.action.move_to(find_element("//"+attr+"[" + identifier + "]")).perform
    find_element("//"+attr+"[" + identifier + "]").click
  end

  def move_click(identifier, attr = "button")
    @driver.action.move_to(find_element("//"+attr+"[" + identifier + "]")).perform
    find_element("//"+attr+"[" + identifier + "]").click
  end
  def click_attr(attr, identifier)
    find_element("//"+attr + "[" + identifier + "]").click
  end

  def sendkeys(text)
    @driver.action.send_keys(text).perform
  end

  def click_div()

  end

  def do_job
    driver = @driver
    wait = @wait

    driver.get 'https://seller.tokopedia.com/add-product'
    fill("@class='js__input-register unf-user-input__control error-border'",@username)
    sleep(2)
    wait_click("@class='js__submit-register unf-user-btn unf-user-btn--primary unf-user-btn--block'")
    wait_click("@class='js__submit-email btn btn-action btn--register'")
    fill("@class='js__input-form unf-user-input__control'",@username)
    sleep(1)
    wait_click("@class='js__continue-login-form unf-user-btn unf-user-btn--medium unf-user-btn--primary unf-user-btn--block'")
    sleep(1)
    wait_click("@class='js__password-form unf-user-input__control unf-user-input__control--icon'", 'input')
    fill("@class='js__password-form unf-user-input__control unf-user-input__control--icon'",@password)
    wait_click("@class='js__btn-login-form unf-user-btn unf-user-btn--medium unf-user-btn--primary unf-user-btn--block'")
    sleep(1)
    click_attr("img","@class='cotp__image cotp-img--sms'")
    wait_click("@class='otp-number-input mr-10 otp-desktop-input'",'input')
    print 'Masukkan OTP : '
    retry_max = 20
    $i = 0
    otp = 0
    url = 'https://mooka-api.appspot.com/associatied_accounts/' + @ac_id
    while $i < retry_max  do
      resp = Faraday.get(url)
      if (!resp.body.nil? && !JSON.parse(resp.body)['otp'].empty?)
        otp = JSON.parse(resp.body)['otp']
        $i+=10
      end
      $i +=1;
      sleep(5)
    end
    # otp = gets
    sendkeys(otp)
    wait.until { find_element("//button[@class='css-1qmbai4-unf-btn e7i7yvm0']").displayed? }
    driver.get 'https://seller.tokopedia.com/add-product'
    sendkeys(:escape)
    pwd = Dir.pwd
    fill("@accept='image/x-png,image/png,image/jpg,image/jpeg'",pwd+'/photo/' + @image)

    move_click("@name='productName'",'input')
    fill("@placeholder='Contoh: Sepatu Pria (Jenis/Kategori Produk) + Tokostore (Merek) + Kanvas Hitam (Keterangan)'", @title)
    sleep(2)
    move_click("@class='unf-radio-button'",'input')
    move_click("@class='unf-input-textarea'",'textarea')
    sendkeys @description
    move_click("@name='price'",'input')
    fill("@name='price'", @price)
    move_click("@name='stock'",'input')
    sleep(1)
    fill("@name='stock'", @qty)
    move_click("@name='weight'",'input')
    fill("@name='weight'", @berat)

    move_click("@class='unf-btn unf-btn__primary unf-btn__medium css-a645p1'")
    sleep(5)
    current_url = driver.current_url
    data = {
      link: current_url,
      status: "SUCCESS"
    }
    Faraday.put('https://mooka-api.appspot.com/associatied_accounts/' + @ac_id) do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(data)
    end
    sleep(5)
  end
end