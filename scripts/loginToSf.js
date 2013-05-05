// OAuth Configuration
var loginUrl = 'https://login.salesforce.com/';
var clientId = '3MVG99qusVZJwhslGI._DuPtlMPe9V0ymb6n.SANvHchAqg0mhEPhPz6lDQ71b5RS8bMeYeCSLIlfsJBWwNx7';
var redirectUri = 'https://login.salesforce.com/services/oauth2/success';

var client = window.client || new forcetk.Client(clientId, loginUrl);

var logedinCallback = window.logedinCallback || function (oauthResponse) { log(JSON.stringify(oauthResponse)); };

function getAuthorizeUrl(loginUrl, clientId, redirectUri) {
	return loginUrl + 'services/oauth2/authorize?display=touch'+ '&response_type=token&client_id=' + escape(clientId) + '&redirect_uri=' + escape(redirectUri);
}

function sessionCallback(loc) {
	var oauthResponse = {};

	var fragment = loc.split("#")[1];
	log('fragment: ' + fragment);

	if (fragment) {
		var nvps = fragment.split('&');
		for (var i = 0; i < nvps.length; ++ i) {
			var parts = nvps[i].split('=');
			oauthResponse[parts[0]] = unescape(parts[1]);
		}
	}

	if (oauthResponse['access_token']) {
		log('Unauthorized: No OAuth response.');
		return;
	}

	client.setSessionToken(oauthResponse.access_token, null, oauthResponse.instance_url);

	logedinCallback(oauthResponse);
} // sessionCallback(loc)

function loginToSf () {
	if (! window.plugins || ! window.plugins.childBrowser)
		ChildBrowser.install();
	var cb = window.plugins.childBrowser;

	cb.onLocationChange = function(loc){
		if (loc.startsWith(redirectUri)) {
			cb.close();
			log('SF: login success.');
			sessionCallback(unescape(loc));
		}
	};

	cb.showWebPage(getAuthorizeUrl(loginUrl, clientId, redirectUri));
}
