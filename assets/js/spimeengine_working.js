/******************************************************************************************************
 *                                             SPIME ENGINE 
 ******************************************************************************************************/

var SpimeEngine = {};

/******************************************************************************************************
 *                                               GLOBALS 
 ******************************************************************************************************/
SpimeEngine.debugMode = false; //When set to true console logs will be shown
SpimeEngine.arrangers = {}; // An array of all the arrangers in the page
SpimeEngine.layouts = {}; //An array of all the layouts in the page
SpimeEngine.captchaKey = (document.location.hostname == "127.0.0.1" || document.location.hostname == "localhost") ? "6LdmEiUUAAAAAJBHO4Pb7MdtE5Et1jN1Wk4wjOBr" : "6Lc2KCUUAAAAAGP2G2L0bhHTq_hcnbo_we19MIXA";
SpimeEngine.YTPlayers = {};
SpimeEngine.Geocoder = {};
SpimeEngine.GoogleMaps = {};
SpimeEngine.ecommerceSolution = "";
SpimeEngine.stripePaymentHandler = {};
SpimeEngine.stripePaymentParams = {};
SpimeEngine.scrollEnabled = true;
SpimeEngine.finishedLoading = false;

/******************************************************************************************************
 *                                               MAIN
 *                                  called from body onLoad func    
 ******************************************************************************************************/
SpimeEngine.start = function(){
	$(document).ready(function() {
		SpimeEngine.updateParent({"deliver_to":"parent","action":"finished-loading"});
		SpimeEngine.finishedLoading = true;
	});
	try{ 
		SpimeEngine.BeforeInit();
		SpimeEngine.InitMaster();
		var c = 0
		SpimeEngine.getAllHolders().each(function(){
			var currentHolder = $(this);
			// setTimeout(function(){
				SpimeEngine.InitHolder(currentHolder);	
			// },10 *c )
			c++;
		});
		SpimeEngine.initForms();
		LightBox.initLinks();
		SpimeEngine.initVideos();
		if(typeof window["EditorHelper"] != "undefined"){
			SpimeEngine.initMaps();
		}else{//MAPSFIX
			SpimeEngine.initMapsEmbed();
		}
		SpimeEngine.initDynamicStripes();
		SpimeEngine.AttachHelperIfNeeded();
		SpimeEngine.AfterInit();
		SpimeEngine.initAnchors();
		SpimeEngine.initProducts();//ECOMMERCE
		setTimeout(function(){
			SpimeEngine.loadHighResImages();	
		},1500);
		SpimeEngine.initRawHTMLs();
		var hasScrollEffects = $(".master.container").hasClass("scroll-effects");
		var hasItemEnterEffects = $(".master.item-box.items-enter-effects").length > 0;
		//first init of sections visibility
		if (hasScrollEffects || hasItemEnterEffects || typeof window["EditorHelper"] != "undefined"){
			SpimeEngine.handleScrollEffects();
		}
		if (getParameterByName("show_site")){
			$('body,html').animate({
					scrollTop: $(document).height()
				}, 4000);
			setTimeout(function(){
				$('body,html').animate({
						scrollTop: 0
					}, 2000);
			},4500)
		}
		}catch(err){
			console.log(err);
			console.trace();
			console.error("something went wrong... (Engine) " + err)
			var errorMessage = $("#error").html();
			$("#content").html(errorMessage);
		}
};

/******************************************************************************************************
 *                                               INIT
 *                                 The following methods are only called once
 ******************************************************************************************************/

SpimeEngine.BeforeInit = function(){
	SpimeEngine.UpdateDeviceClass();
	var scrollingContainer = $(document);
	var hasScrollEffects = $(".master.container").hasClass("scroll-effects");
	var hasItemEnterEffects = $(".master.item-box.items-enter-effects").length > 0;
	SpimeEngine.handleParallax();
	scrollingContainer.unbind("scroll").bind("scroll",function(event){
		if (SpimeEngine.scrollEnabled){
			if(typeof window["EditorHelper"] != "undefined"){
				EditorHelper.handleScroll(event);
			}
			if ("menu" in SpimeEngine.layouts){
				if (typeof SpimeEngine.layouts["menu"].handleScroll != "undefined"){
					SpimeEngine.layouts["menu"].handleScroll($("[data-preset-type-id='MENUS']"),$(this).scrollTop());
				}
			}
			SpimeEngine.handleParallax();
			if (hasScrollEffects || hasItemEnterEffects || typeof window["EditorHelper"] != "undefined"){
				SpimeEngine.handleScrollEffects();
			}
		}
		if (typeof popupStripeAppOnScroll == 'function') { 
			setTimeout(function(){
				popupStripeAppOnScroll(); 
			},300);
		}
	});
};

SpimeEngine.loadHighResImages = function(){
	SpimeEngine.loadHighResImage($(".stripe_popup_app_hide .load-high-res").not("#no-image"),1600);
	var c = 0;
	$(".load-high-res").not(".from-feed").not("#no-image").each(function(){
		var currentImg = $(this);
		setTimeout(function(){
			SpimeEngine.loadHighResImage(currentImg);
		},10 *c )
		c++;
	});
};

SpimeEngine.loadHighResImage = function(imgDiv,forceNewRes){
	if (imgDiv.length == 0){
		return;
	}
	imgDiv.removeClass("load-high-res")
	var currentSrc = imgDiv.css("background-image");
	var currentWidth = imgDiv.width();
	var currentHeight = imgDiv.height();
	var newRes = Math.max(currentWidth,currentHeight);
	newRes = Math.min(newRes,1600);
	if(typeof window["EditorHelper"] != "undefined"){
		newRes = 1600;
	}
	if (isNaN(newRes)){
		newRes = 1200;
	}
	if (forceNewRes){
		newRes = forceNewRes;
	}
	var backgroundZoom = imgDiv.css("background-size");
	if (typeof backgroundZoom != "undefined"){
		if (backgroundZoom.indexOf("%") != -1){
			if (parseInt(backgroundZoom) > 100){
				newRes = 1600;
			}
		}else if(backgroundZoom == "cover"){
			var tempRes = Math.max(currentWidth,currentHeight);
			if (forceNewRes){
				tempRes = forceNewRes;
			}
			tempRes*=2;
			tempRes = Math.min(tempRes,1600);
			newRes = tempRes;
		}
	}
	// Check if image is local (in images/ folder) - don't add size parameters
	if (currentSrc.indexOf("images/") !== -1) {
		// Local image, do nothing
		return;
	}
	var newSrc = currentSrc.replace("=s300","=s"+newRes);
	var finalSrc =  newSrc + "," +currentSrc
	imgDiv.css("background-image",finalSrc);
	setTimeout(function() {
		SpimeEngine.removeLowResimg(imgDiv);
	}, 1000);
};

SpimeEngine.shrinkImg = function(container){
	container.closest(".master.item-box").find(".shrinkable-img").each(function(){
		var currentImg = $(this);
		var imgWidth = currentImg.width()
		if (currentImg.attr("data-width-before-shrink")){
			imgWidth = parseInt(currentImg.attr("data-width-before-shrink"));
		}else{
			currentImg.attr("data-width-before-shrink",imgWidth);
			var loadWidth = imgWidth*2;
			// Don't add size parameters to local images
			if (currentImg.attr("src").indexOf("=s") == -1 && currentImg.attr("src").indexOf("images/") === -1){
				currentImg.attr("src", currentImg.attr("src") + "=s" + loadWidth);
			}
		}
		if (container.width() < imgWidth){
			if (container.closest(".master.item-box").is("[data-preset-type-id='MENUS']")){
				current Img.css("width","70%");
			}else{
				currentImg.css("width","100%");
			}
			
			currentImg.addClass("shrinked");
		}else{
			if (currentImg.is(".shrinked")){
				currentImg.removeClass("shrinked");
				currentImg.css("width","");
			}
		}
	});
};
