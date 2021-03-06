require 'rho/rhocontroller'

class SignatureUtilController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Signature index controller"
    @signatures = SignatureUtil.find(:all)
    render :back => '/app'  
  end

  def new
    Rho::SignatureCapture.take(url_for( :action => :signature_callback), { :imageFormat => "jpg", :penColor => 0xff0000, :penWidth=>3, :border => true, :bgColor => 0x00ff00 })
    redirect :action => :index
  end

  def delete
    @signature = SignatureUtil.find(@params['id'])
    @signature.destroy
    redirect :action => :index
  end

  def signature_callback
    if @params['status'] == 'ok'
      #create signature record in the DB
      signature = SignatureUtil.new({'signature_uri'=>@params['signature_uri']})
      signature.save
      puts "new Signature object: " + signature.inspect
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    ""
  end

  def inline_capture
    Rho::SignatureCapture.visible(true, :penColor => 0xff0000, :penWidth=>1, :border => true, :bgColor => 0x00ff00 )
  end

  def do_capture          
    Rho::SignatureCapture.capture(url_for( :action => :signature_callback))    
  end
  
  def clear_capture          
    Rho::SignatureCapture.clear()    
  end
  
end
