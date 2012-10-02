class PagesController < ApplicationController
  autocomplete :disease, [:disease_name, :omim_id], :full => true
  
  def home
    @keyword = ""
    @title = 'Home'
  end
  
  def about
    @title = 'About'
  end

  def contact
    @title = 'Contact'
  end
  
  def help
    @title = 'Help'
  end

end
