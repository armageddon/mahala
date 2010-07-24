class FacebookController < ApplicationController
  require 'mini_fb'
  skip_before_filter :verify_authenticity_token, :only => [:post_from_m,:post_to_newsfeed, :allow_page_admin]

  def get_pages
    begin
      @response_hash = MiniFB.get(@access_token, @uid, :type=>'accounts')
      @response_hash.data.each do |p|
        page = Page.new
        page.access_token = p.access_token
        page.administrator_id = @uid
        page.name = p.name
        page.page_id = p.id
        page.save
      end
      logger.debug(@page_access_token)
      logger.debug(@response_hash)
    rescue
      logger.error("Error")
    end
  end

  def decode_cookie
    split_char = '='
    if params[:session].present?
      logger.debug("session" +params[:session])
      access_token = ""
      sess = params[:session].chomp('}').reverse.chomp('{').reverse
      sess=sess.sub!('"','')
      valar = sess.split(',')
      split_char = ':'
    else
      logger.debug("cookie")
      val = ""
      uid = 0
      access_token = ""
      values = {}
      cookies.each do |c, v|
        logger.debug(c)
        if c=="fbs_"+FB_APP_ID.to_s
          logger.debug(v)
          val = v
        end
      end
      valar = val.split("&")
    end
    valar.each do |f|
      item = f.split(split_char)
      if item.length==2
        uid = item[1].reverse.chomp('"').reverse.chomp('"') if item[0].reverse.chomp('"').reverse.chomp('"') == "uid"
        access_token = item[1].reverse.chomp('"').reverse.chomp('"') if item[0].reverse.chomp('"').reverse.chomp('"') == "access_token"
      end
    end
    values = {:uid=>uid,:access_token=>access_token}
    values
  end

  def index
    #@oauth_url = MiniFB.oauth_url(FB_APP_ID, CALLBACK_URL+"?path=account", # redirect url
    # :scope=>MiniFB.scopes.join(",")+",offline_access,email", :display=>"popup")
    logger.info(params)
    MiniFB.enable_logging
    @uid = ""
    @access_token = ""
    @access_token =  decode_cookie[:access_token]
    @uid =  decode_cookie[:uid]
    @hp_user = Artist.find_by_fb_user_id(@uid)
    begin
      @fb_user = MiniFB.get(@access_token,'me')
      @first_name = @fb_user.first_name
    rescue
      @first_name = ""
    end
    
    if @hp_user != nil && @hp_user.admin ==1     
      render :template => 'facebook/admin',:layout=>false
    elsif @hp_user != nil
      logger.debug('admin')
      render :template => 'facebook/partner',:layout=>false
    else
      render :template => 'facebook/login',:layout=>false
    end
    cookies[:path] = "account"
  end

  def facebook_events

  end

  def facebook_stats
    MiniFB.enable_logging
    pages = Page.find(:all)
    artist = Artist.find(:last)
    logger.info(pages.length)
    @pages = []
    pages.each do |p|
     
      # @response_hash = MiniFB.get(p.access_token, p.page_id, {:session_key=>})
      #logger.debug(MiniFB.rest(p.access_token,'pages.getinfo',{:key=>FB_APP_KEY,:page_id=>p.page_id,:fields=>'name'}))
      # @pages << MiniFB.get(p.access_token, p.fb_user_id, :type=>'friends')
      #@pages << MiniFB.get(p.access_token.to_s, p.page_id)
      @access_token = p.access_token
      @page_id = p.page_id
      logger.info('PAGE EVENTS')
      q="select eid, name, creator,host  from event where creator = " + @page_id.to_s
      logger.debug(q)
      @events1 = MiniFB.fql(@access_token, q)
      logger.info(@events1)
      logger.info('AFTER')
      # logger.info(MiniFB.get(@access_token, @page_id, :type=>'events'))
      @pages << MiniFB.get(@access_token, @page_id)
      #@pages << MiniFB.get(@access_token, @page_id).fan_count
      #      @pages << MiniFB.get(Page.find(2).access_token, Page.find(2).page_id).fan_count
      #   @pages << MiniFB.get(Page.find(:last).access_token, Page.find(:last).page_id).fan_count
      #q="select name,  from page where page_id  =" + p.page_id.to_s

      # @pages << MiniFB.fql(visitor.access_token, q)
    end
    
    render :template => 'facebook/stats' , :locals=>{:pages => @pages}, :layout => false;
  end

  def facebook_tab
    render :template => 'facebook/show', :layout=>false
  end

  def allow_page_admin
    artist_id = params[:artist_id]
    page_id = params[:page_id]
    allow = params[:allow]
    logger.debug(params)
    page = Page.find_by_administrator_id_and_page_id(artist_id, page_id)
    page.allow=allow
    page.save

    render :nothing
  end

  def allow_page
    artist_id = params[:artist_id]
    page_id = params[:page_id]
    allow = params[:allow]
    logger.debug(params)
    if allow=='false'
      aap = ArtistAllowedPage.find_by_artist_id_and_page_id(artist_id, page_id)
      aap.destroy
    else
      aap = ArtistAllowedPage.new(:artist_id => artist_id, :page_id => page_id)
      aap.save
    end
    render :nothing
  end
  
  def post_to_newsfeed
    logger.info(params)
    fb_page_id = params[:fb_page_id]
    logger.info('POST TO NEWSFEED')
    ret = ""
    #pages.each do |p|
    pages=Page.find(:all, :conditions=>"allow=1")
    pages.each do |p|
      aap = ArtistAllowPage.find_by_artist_id_and_page_id(p.administrator_id, fb_page_id)
      if aap != nil
        @access_token = p.access_token
        @uid = p.page_id
        ret = MiniFB.post(@access_token, @uid, :type=>'feed',  :message=>params[:post_text], :link=>"http://www.blog.lovecapetownmusic.com", :name=>'Mahala Music' ,:description=> 'Everything you ever wanted',  :caption => "free MP3 downloads at Mahala Music"  ,:picture => "http://blog.lovecapetownmusic.com/wp-content/uploads/mahalalogo.png")
      end
    end
    render :text => ret
    #MiniFB.post(@access_token,  )
  end

  def post_from_m
    page = Page.find(5)
    @access_token = page.access_token
    @uid = page.page_id
    logger.debug(params)
    #ret = MiniFB.post(@access_token, @uid, :type=>'feed',  :message=>DateTime.now.to_s)
    render :text => 'ret'
  end

  def new_visitor
    @uid = ""
    @access_token = ""
    val = ""
    cookies.each do |c, v|
      if c=="fbs_"+FB_APP_ID.to_s
        logger.debug(v)
        val = v
      end
    end
    valar = val.split("&")
    logger.debug(valar.length)
    valar.each do |f|
      item = f.split("=")
      if item.length==2
        logger.debug( item[0] + '      ' +  item[1])
        @uid = item[1].chomp('"') if item[0] == "uid"
        @access_token = item[1].chomp('"') if item[0].reverse.chomp('"').reverse == "access_token"
      end
    end
    v = Artist.new
    v.fb_user_id = @uid
    v.access_token =@access_token
    v.save
    get_pages
    render :text=>"success"
  end

  def callback
    MiniFB.enable_logging
    logger.info(params)
    if params[:code].present?
      access_token_hash = {}
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, CALLBACK_URL, FB_SECRET_KEY, params[:code])
      @access_token = access_token_hash["access_token"]
      logger.info(@access_token)
      cookies[:access_token] = @access_token
    else
      logger.info('NO CODE PARAMS PRESENT')
    end
   
    cookies[:access_token] = @access_token
    logger.info('ACCESS TOKEN'  + @access_token.to_s)
    begin
      @user = MiniFB.get(@access_token, 'me')
    rescue
      logger.info('RESCUE')
      redirect_to "/" and return
    end
    user = User.find_by_fb_user_id(@user.id)
    if user != nil
      self.current_user = User.find_by_fb_user_id(@user.id)
      self.current_user.access_token = @access_token
      self.current_user.save
      redirect_to "/" and return
    else
      logger.debug('redirecting to link_page')
      redirect_to "/account/link" and return
    end
  
    redirect_to "/account"
  end

  def fb_pull
    FbGrapher.pull(User.find_by_username("pierrearmageddon").access_token)
  end

end