class PagesController < ApplicationController
  autocomplete :disease, [:disease_name, :omim_id], :full => true
  
  def home
    @keyword = ""
    @title = 'Home'
  end
  
  def about
    @title = 'About'
    render :layout => "noLayout"  #These pages are in pop window, no need for layout
  end

  def contact
    @title = 'Contact'
    render :layout => "noLayout"
  end
  
  def help
    @title = 'Help'
    render :layout => "noLayout"
  end

end
