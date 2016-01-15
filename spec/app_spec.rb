#!/usr/bin/env ruby
require_relative 'spec_helper'
require_relative './page_objects/login_page'

require 'json'

describe 'Shopping for items' do
  before do
    unless @browser
      @headless = Headless.new
      @browser = Watir::Browser.new
    end
    @browser.goto 'localhost:9292'
  end

  describe 'Go to home page' do
    it 'tries to login' do
      login = LoginPage.new(@browser)
      login.login_with 'ted@gmail.com'
    end
  end

=begin
  describe 'Checks categories' do
    it 'looks for the latest items' do
      @browser.text_field(name: 'keyword').set 's'
      @browser.button(name: 'submit').click
      @browser.table(class: 'center').rows.count.must_be :>=, 30
    end
  end
=end

  after do
    @browser.close
    # @headless.destroy
    # destroy causes test to hang need to dig into this issue
  end
end
