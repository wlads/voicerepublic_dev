class LandingPageController < ApplicationController
  
  def index
    @kluuus = Kluuu.published.paginate(:page => params[:page], :per_page => 8).order("created_at DESC")
    @no_kluuus = NoKluuu.published.paginate(:page => params[:page], :per_page => 8).order("created_at DESC")
  end
  
end
