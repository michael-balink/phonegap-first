<apex:page showHeader="false" standardStylesheets="false">

    <apex:includeScript value="{! UrlFor($Resource.phonegap_js, 'jquery-1.9.1.min.js') }" />
<!-- 
    <apex:includeScript value="{! UrlFor($Resource.phonegap_js, 'cordova.ios.js') }" />
    <apex:includeScript value="{! UrlFor($Resource.phonegap_js, 'childbrowser.js') }" />
 -->    
    <apex:includeScript value="{! UrlFor($Resource.phonegap_js, 'forcetk.js') }" />

    <script type="text/javascript">
        function log (txt) {
            //setTimeout (function() { alert (txt);}, 0);
            $ ('#log').append ($ ('<li>').append ('<pre>').html (txt));
        }

        String.prototype.startsWith = function (str) { return (this.substr(0, str.length) === str); }

        function deviceReady () {
            
            
/* login related
            // OAuth Configuration
            var loginUrl = 'https://login.salesforce.com/';
            var clientId = '3MVG99qusVZJwhslGI._DuPtlMPe9V0ymb6n.SANvHchAqg0mhEPhPz6lDQ71b5RS8bMeYeCSLIlfsJBWwNx7';
            var redirectUri = 'https://login.salesforce.com/services/oauth2/success';

            var client = new forcetk.Client(clientId, loginUrl);

            function getAuthorizeUrl(loginUrl, clientId, redirectUri) {
                return loginUrl + 'services/oauth2/authorize?display=touch'
                + '&response_type=token&client_id=' + escape(clientId)
                + '&redirect_uri=' + escape(redirectUri);
            };

            function sessionCallback(loc) {
                var oauthResponse = {};

                var fragment = loc.split("#")[1];

                if (fragment) {
                    var nvps = fragment.split('&');
                    for (var i = 0; i < nvps.length; ++ i) {
                        var parts = nvps[i].split('=');
                        oauthResponse[parts[0]] = unescape(parts[1]);
                    }
                }

                if (typeof oauthResponse['access_token'] === 'undefined') {
                    log('Unauthorized: No OAuth response.');
                    return;
                }

                client.setSessionToken(oauthResponse.access_token, null, oauthResponse.instance_url);

                querySF ();
            } // sessionCallback(loc)\
//*/
/* DB related
            var db = (function db_func () {
                var db = window.openDatabase('test', '1.0', 'Test DB', 1000000);

                function create(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS Lead (Id UNIQUE, Name)'); }
                function fail(tx, err) { log("Error processing SQL: "+JSON.stringify(arguments)); }
                function success(tx, err) { log("DB created: "+JSON.stringify(arguments)); }

                db.transaction(create, fail, success);

                return db;
            })();

            function insertToDb(r) {
                db.transaction(
                    function (tx) {
                        tx.executeSql(
                            'INSERT INTO Lead (Id, Name) VALUES (?,?)',
                            [ r.Id, r.Name ],
                            function (tx, err) { log('Insert ('+r.Id+') :: SQL success: ' + JSON.stringify(arguments)); },
                            function (tx, err) { log('Insert ('+r.Id+') :: SQL failed: '  + JSON.stringify(arguments)); }
                        ); // executeSql INSERT
                    }, // transaction exec
                    function (tx, err) { log('Insert Transaction ('+r.Id+') :: SQL failed: '  + JSON.stringify(arguments)); },
                    function (tx, err) { log('Insert Transaction ('+r.Id+') :: SQL success: ' + JSON.stringify(arguments)); }
                ); // transaction
            }

            function queryAllDb() {
                db.transaction(
                    function (tx) {
                        tx.executeSql(
                            'SELECT Id, Name FROM Lead',
                            [],
                            function (tx, r) {
                                try {
                                    //log('Select :: SQL success: ' + JSON.stringify(arguments)); // buggy r

                                    var rows = r.rows;
    
                                    $('#result tbody').remove ();
                                    if (rows.length === 0) {
                                        log('No data selected in DB.');
                                        return;
                                    }
    
                                    log(rows.length + ' retrived from DB.');
                                    var $t = $('#result').append('<tbody>');
                                    for (var i = 0; i < rows.length; ++ i) {
                                        var row = rows.item(i);
                                        log('Select :: selected row: ' + JSON.stringify(row));
                                        $t.append('<tr><td>'+row.Id+'</td><td>'+row.Name+'</td></tr>');
                                    }
                                } catch (e) {
                                    log('Select :: smthn goes wrong... ' + JSON.stringify(e));
                                    return false; // break transaction
                                }

                                return true;
                            },
                            function (tx, err) { log('Select :: SQL failed: ' + JSON.stringify(arguments)) }
                        ); // executeSql SELECT
                    }, // transaction exec
                    function (tx, err) { log('Select Transaction :: SQL failed: '  + JSON.stringify(arguments)); },
                    function (tx, err) { log('Select Transaction :: SQL success: ' + JSON.stringify(arguments)); }
                ); // transaction
            }
//*/
/*
            log('Connection: ' + JSON.stringify(Connection));
            log('navigator.connection: ' + JSON.stringify(navigator.connection));
            if (Connection.NONE !== navigator.connection.type)
                (function login () {
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
                })(); // login()
//*/
            function querySF () {
                client.query(
                    'SELECT Id, Name FROM Lead LIMIT 1',
                    (function (r) {
                        log('Downloaded from SF: ' + JSON.stringify(arguments));

                        $('#result tbody').remove ();
                        if (r.records.length === 0) {
                            log('No data selected in Salesforce.');
                            return;
                        }

                        log(r.records.length + ' retrived from SF.');
                        var $t = $('<tbody>').appendTo('#result');
                        $.each(
                            r.records,
                            function (k, v) {
                                $t.append('<tr><td>'+v.Id+'</td><td>'+v.Name+'</td></tr>');
                                insertToDb(v);
                            }
                        );
                    })
                );
            }
//*/
/* demo data
            (function () {
                insertToDb({ "Id": "1111", "Name": "AAAA"});
                insertToDb({ "Id": "1111", "Name": "AAAA"}); // will fail
                insertToDb({ "Id": "2222", "Name": "BBBB"});
            })();
//*/
            $('#showDB').click(queryAllDb);
            //TODO insertToDb
        }

        function onLoad () {
            alert('onLoad');
            //document.addEventListener ("deviceready", deviceReady, false);
            deviceReady(); // device should be ready;
        }
    </script>

<body onload="onLoad()">
    <p>
        <button type="button" name="showDB" id="showDB">Show DB</button>
        <!-- <button type="button" name="insert" id="insert">Insert</button> -->
    </p>

    <p>
        <table id="result">
            <caption>DB</caption>
        </table>
    </p>

    <br />
    <ul id="log"></ul>
</body>

</apex:page>