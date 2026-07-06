[#ftl/]
[#setting url_escaping_charset="UTF-8"]
[#-- Below are the main blocks for all of the themeable pages --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="bypassTheme" type="boolean" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="code_challenge" type="java.lang.String" --]
[#-- @ftlvariable name="code_challenge_method" type="java.lang.String" --]
[#-- @ftlvariable name="consents" type="java.util.Map<java.util.UUID, java.util.List<java.lang.String>>" --]
[#-- @ftlvariable name="editPasswordOption" type="java.lang.String" --]
[#-- @ftlvariable name="locale" type="java.util.Locale" --]
[#-- @ftlvariable name="loginTheme" type="io.fusionauth.domain.Theme.Templates" --]
[#-- @ftlvariable name="metaData" type="io.fusionauth.domain.jwt.RefreshToken.MetaData" --]
[#-- @ftlvariable name="nonce" type="java.lang.String" --]
[#-- @ftlvariable name="passwordValidationRules" type="io.fusionauth.domain.PasswordValidationRules" --]
[#-- @ftlvariable name="pendingIdPLinkId" type="java.lang.String" --]
[#-- @ftlvariable name="redirect_uri" type="java.lang.String" --]
[#-- @ftlvariable name="response_mode" type="java.lang.String" --]
[#-- @ftlvariable name="response_type" type="java.lang.String" --]
[#-- @ftlvariable name="scope" type="java.lang.String" --]
[#-- @ftlvariable name="state" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]
[#-- @ftlvariable name="timezone" type="java.lang.String" --]
[#-- @ftlvariable name="user_code" type="java.lang.String" --]
[#-- @ftlvariable name="version" type="java.lang.String" --]

[#if request.requestURI?contains("password/forgot")]
	[#assign redirect_uri="${tenant.data.baseCentrURL}/auth/login"]
[/#if]

[#-- Get country code from FusionAuth's IP-based location detection --]
[#function getCountryCode]
  [#assign currentLocation = fusionAuth.currentLocation()!{}]
  [#if currentLocation?has_content && currentLocation.country?has_content]
    [#return currentLocation.country]
  [#else]
    [#return '']
  [/#if]
[/#function]

[#--
  Determine if the user's country requires an opt-in checkbox for marketing communications.
  UK, EU countries, Canada, and Australia require explicit opt-in (checkbox).
  All other countries (including US) get auto opt-in with informational copy.

  Returns: true if checkbox should be shown, false for informational copy only
--]
[#function requiresOptInCheckbox]
  [#assign country = getCountryCode()]
  [#-- UK --]
  [#if country == 'GB']
    [#return true]
  [/#if]
  [#-- EU member states --]
  [#assign euCountries = ['AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE']]
  [#if euCountries?seq_contains(country)]
    [#return true]
  [/#if]
  [#-- Canada --]
  [#if country == 'CA']
    [#return true]
  [/#if]
  [#-- Australia --]
  [#if country == 'AU']
    [#return true]
  [/#if]
  [#-- All other countries (including US) --]
  [#return false]
[/#function]

[#macro html]
<!DOCTYPE html>
<html lang="en">
  [#nested/]
</html>
[/#macro]

[#macro head title="Centr | Account Auth" author="FusionAuth" description="User Management Redefined. A Single Sign-On solution for your entire enterprise."]
<head>
  <title>${title}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="application-name" content="FusionAuth">
  <meta name="author" content="FusionAuth">
  <meta name="description" content="${description}">
  <meta name="robots" content="index, follow">

  [#-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy --]
  <meta name="referrer" content="strict-origin">

  [#--  Browser Address bar color --]
  <meta name="theme-color" content="#ffffff">

  [#-- Begin Favicon Madness
       You can check if this is working using this site https://realfavicongenerator.net/
       Questions about icon names and sizes? https://realfavicongenerator.net/faq#.XrBnPJNKg3g --]

  [#-- Apple & iOS --]
  <link rel="apple-touch-icon" sizes="57x57" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="60x60" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="72x72" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="76x76" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="114x114" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="120x120" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="144x144" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="152x152" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-180x180.png">

  [#-- Android / PWA --]
  <link rel="icon" type="image/png" sizes="192x192" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/android-icon-192x192.png">
  <link rel="manifest" href="/images/manifest.json">

  [#-- IE 11+ configuration --]
  <meta name="msapplication-config" content="/images/browserconfig.xml" />

  [#-- Windows Tiles --]
  <meta name="msapplication-TileColor" content="#ffffff">
  <meta name="msapplication-TileImage" content="https://prod-cdn.centr.com/deploy/static/icons/rebrand/apple-icon-144x144.png">

  [#-- Standard Favicons --]
  <link rel="icon" type="image/png" sizes="16x16" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/favicon-16x16.png">
  <link rel="icon" type="image/png" sizes="32x32" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="96x96" href="https://prod-cdn.centr.com/deploy/static/icons/rebrand/favicon-96x96.png">

  [#-- End Favicon Madness --]

  [#-- Font preloading to prevent FOUT (Flash of Unstyled Text) --]
  <link rel="preload" href="https://prod-cdn.centr.com/deploy/static/fonts/SuisseIntl-Regular-WebM.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preload" href="https://prod-cdn.centr.com/deploy/static/fonts/SuisseIntl-Bold-WebM.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preload" href="https://prod-cdn.centr.com/deploy/static/fonts/SuisseIntl-Black-WebM.woff2" as="font" type="font/woff2" crossorigin>

  <link rel="stylesheet" href="/css/font-awesome-4.7.0.min.css"/>

  [#-- Theme Stylesheet, only Authorize defines this boolean.
       Using the ?no_esc on the stylesheet to allow selectors that contain a > symbols.
       Once insde of a style tag we are safe and the stylesheet is validated not to contain an end style tag --]
  [#if !(bypassTheme!false)]
    <style>
    ${theme.stylesheet()?no_esc}
    </style>
  [/#if]

  <script src="${request.contextPath}/js/prime-min-1.7.0.js?version=${version}"></script>
  <script src="${request.contextPath}/js/Util.js?version=${version}"></script>
  <script src="${request.contextPath}/js/oauth2/LocaleSelect.js?version=${version}"></script>
  
  [#-- Analytics integration --]
  [@helpers.analytics/]
  <script>
    "use strict";
    Prime.Document.onReady(function() {
      Prime.Document.query('.alert').each(function(e) {
        var dismissButton = e.queryFirst('a.dismiss-button');
        if (dismissButton !== null) {
          new Prime.Widgets.Dismissable(e, dismissButton).initialize();
        }
      });
      Prime.Document.query('[data-tooltip]').each(function(e) {
        new Prime.Widgets.Tooltip(e).withClassName('tooltip').initialize();
      });
      Prime.Document.query('.date-picker').each(function(e) {
        new Prime.Widgets.DateTimePicker(e).withDateOnly().initialize();
      });
      [#-- You may optionally remove the Locale Selector, or it may not be on every page. --]
      var localeSelect = Prime.Document.queryById('locale-select');
      if (localeSelect !== null) {
        new FusionAuth.OAuth2.LocaleSelect(localeSelect);
      }
    });
    FusionAuth.Version = "${version}";
  </script>
  <script>
    function togglePassword(id, btn) {
      var input = document.getElementById(id);
      if (!input) return;
      var showIcon = btn.querySelector('.icon-show');
      var hideIcon = btn.querySelector('.icon-hide');
      if (input.type === 'password') {
        input.type = 'text';
        btn.classList.add('showing');
        if (showIcon && hideIcon) {
          showIcon.style.display = 'none';
          hideIcon.style.display = '';
        }
      } else {
        input.type = 'password';
        btn.classList.remove('showing');
        if (showIcon && hideIcon) {
          showIcon.style.display = '';
          hideIcon.style.display = 'none';
        }
      }
    }
  </script>

  [#-- The nested, page-specific head HTML goes here --]
  [#nested/]

</head>
[/#macro]

[#macro analytics]
  [#-- Environment and analytics ID assignment (replaced by build script) --]
  [#assign environmentName = "staging" /]
  [#assign gtmID = "GTM-NVLCPZ4M" /]
  [#assign amplitudeApiKey = "be5804bb69c741f7b2f16c2c182b83a8" /]
  [#assign datadogClientToken = "pub6ef5addfab3afb8d8b2c88dd7f163f5c" /]
  [#assign datadogSite = "us5.datadoghq.com" /]
  [#assign datadogService = "fusionauth" /]

    [#-- Google Tag Manager --]
    <script>
      (function (w, d, s, l, i) {
        w[l] = w[l] || []; w[l].push({
          'gtm.start': new Date().getTime(), 
          event: 'gtm.js'
        }); 
        var f = d.getElementsByTagName(s)[0],
            j = d.createElement(s), 
            dl = l != 'dataLayer' ? '&l=' + l : ''; 
        j.async = true; 
        j.src = 'https://www.googletagmanager.com/gtm.js?id=' + i + dl; 
        f.parentNode.insertBefore(j, f);
      })(
        window,
        document,
        'script',
        'dataLayer',
        '${gtmID}'
      );
    </script>
    <!-- End Google Tag Manager -->

    [#-- Data layer initialization --]
    <script>
      window.dataLayer = window.dataLayer || [];
      
      // FusionAuth context data - available on every page
      const fusionAuthContext = {
        application: {
          id: '${(application.id?js_string)!''}',
          name: '${(application.name?js_string)!''}',
          tenantId: '${(application.tenantId?js_string)!''}',
          clientId: '${(client_id?js_string)!''}'
        },
        tenant: {
          id: '${(tenantId?js_string)!''}'
        },
        system: {
          version: '${(version?js_string)!''}',
          timezone: '${(timezone?js_string)!''}',
          locale: '${(locale?js_string)!''}'
        },
        oauth: {
          redirectUri: '${(redirect_uri?js_string)!''}',
          responseType: '${(response_type?js_string)!''}',
          scope: '${(scope?js_string)!''}',
          state: '${(state?js_string)!''}',
          nonce: '${(nonce?js_string)!''}'
        },
        request: {
          uri: '${(request.requestURI?js_string)!''}',
          contextPath: '${(request.contextPath?js_string)!''}'
        }
      };
      
      // Intercept ALL dataLayer.push calls to ensure FusionAuth context is included
      const originalPush = window.dataLayer.push;
      window.dataLayer.push = function(...args) {
        // Enhance each object with FusionAuth context
        const enhancedArgs = args.map(arg => {
          if (typeof arg === 'object' && arg !== null) {
            return {
              ...arg,
              fusionAuth: fusionAuthContext
            };
          }
          return arg;
        });
        
        return originalPush.apply(this, enhancedArgs);
      };
      
    </script>

    <!-- Amplitude -->
    <script src="https://cdn.amplitude.com/script/${amplitudeApiKey}.js"></script>
    <script>
      // Reduced from 100% to 10% sample rate to cut usage by 90%
      window.amplitude.add(window.sessionReplay.plugin({sampleRate: 0.1}));
      window.amplitude.init('${amplitudeApiKey}', {
        "fetchRemoteConfig": true,
        "autocapture": true  // Disabled to reduce excessive event tracking
      });
    </script>
    <!-- End Amplitude -->

    <!-- Datadog Browser Agent -->
    <script type="text/javascript" src="https://www.datadoghq-browser-agent.com/us5/v5/datadog-logs.js"></script>
    <script>
      if (window.DD_LOGS && window.DD_LOGS.init) {
        window.DD_LOGS.init({
          clientToken: '${datadogClientToken}',
          service: '${datadogService}',
          site: '${datadogSite}',
          forwardErrorsToLogs: true,
          sessionSampleRate: 100,
          env: '${environmentName}'
        });

      // Global error handlers for Datadog logging
      window.addEventListener('error', function(event) {
        if (window.DD_LOGS) {
          window.DD_LOGS.logger.error('FusionAuth JavaScript Error', {
            message: event.message,
            filename: event.filename,
            lineno: event.lineno,
            colno: event.colno,
            error: event.error?.stack,
            tenantId: '${(tenantId?js_string)!''}',
            applicationId: '${(application.id?js_string)!''}',
            page: '${(request.requestURI?js_string)!''}',
            brand: 'centr'
          });
        }
      });

      // Handle unhandled promise rejections
      window.addEventListener('unhandledrejection', function(event) {
        if (window.DD_LOGS) {
          window.DD_LOGS.logger.error('FusionAuth Unhandled Promise Rejection', {
            reason: event.reason,
            tenantId: '${(tenantId?js_string)!''}',
            applicationId: '${(application.id?js_string)!''}',
            page: '${(request.requestURI?js_string)!''}',
            brand: 'centr'
          });
        }
      });
      }
    </script>
    <!-- End Datadog Browser Agent -->
    
    <script>
      // Analytics utilities following main app pattern
      const analyticsUtils = (() => {
        const push = (data) => {
          if (typeof window.dataLayer !== 'object') {
            return;
          }
          window.dataLayer.push(data);
        };

        const track = (object) => {
          push(object);
        };

        const getUserType = () => {
          // For FusionAuth, we'll determine user type based on context
          // This can be enhanced later with actual user data
          return 'Prospect'; // Default for authentication pages
        };

        const trackPageView = (additionalProps = {}) => {
          if (typeof window !== 'undefined') {
            const {
              eventName,
              eventData,
              pageContent,
              overrideTitle,
              overrideCategory
            } = additionalProps;
            
            const url = window.location.pathname + window.location.search;
            const title = overrideTitle
              ? overrideTitle
              : location.pathname.slice(1).split('/')[0] || 'FusionAuth';
            const userType = getUserType();

            const pageInfo = {
              pageID: url.lastIndexOf('/') === url.length - 1
                ? url.slice(0, url.length - 1)
                : url,
              pageTitle: title,
              pageVariant: 'default',
              pageURL: window.location.href,
              domain: window.location.hostname,
              brand: 'centr'
            };

            const trackingDetails = {
              event: eventName ? eventName : 'virtual_page_view',
              ...(eventData ? { eventData: eventData } : {}),
              page: {
                pageInfo,
                category: { 
                  primaryCategory: 'Authentication',
                  subCategory1: 'FusionAuth',
                  subCategory2: '',
                  pageType: 'Auth'
                },
                ...(pageContent ? { content: pageContent } : {})
              },
              user: {
                profileInfo: {
                  userType,
                  brandCustomerId: null,
                  country: '${getCountryCode()?js_string}',
                  linkUserId: null
                }
              }
            };

            track(trackingDetails);
          }
        };

        return {
          trackPageView,
          track
        };
      })();

      // Amplitude utilities following main app pattern
      const amplitudeUtils = {
        track: (eventName, eventProperties) => {
          if (typeof window !== 'undefined' && window.amplitude) {
            window.amplitude.track(eventName, eventProperties);
          }
        },

        identify: (userId, userProperties) => {
          if (typeof window !== 'undefined' && window.amplitude) {
            window.amplitude.setUserId(userId);
            window.amplitude.identify(userProperties);
          }
        }
      };

      // Datadog utilities following main app pattern
      const datadogUtils = {
        log: (message, context = {}) => {
          if (typeof window !== 'undefined' && window.DD_LOGS) {
            window.DD_LOGS.logger.info(message, {
              ...context,
              fusionAuth: fusionAuthContext
            });
          }
        },

        error: (message, error = null, context = {}) => {
          if (typeof window !== 'undefined' && window.DD_LOGS) {
            window.DD_LOGS.logger.error(message, {
              error: error?.message || error,
              stack: error?.stack,
              ...context,
              fusionAuth: fusionAuthContext
            });
          }
        },

        warn: (message, context = {}) => {
          if (typeof window !== 'undefined' && window.DD_LOGS) {
            window.DD_LOGS.logger.warn(message, {
              ...context,
              fusionAuth: fusionAuthContext
            });
          }
        },

        trackEvent: (eventName, eventProperties = {}) => {
          if (typeof window !== 'undefined' && window.DD_LOGS) {
            window.DD_LOGS.logger.info('FusionAuth Event: ' + eventName, {
              eventName,
              eventProperties,
              fusionAuth: fusionAuthContext
            });
          }
        }
      };

      // Track initial page view
      analyticsUtils.trackPageView();

      // FusionAuth-specific error logging
      document.addEventListener('DOMContentLoaded', function() {
        // Log form validation errors
        const forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
          form.addEventListener('submit', function(event) {
            datadogUtils.trackEvent('form_submission', {
              formId: form.id || form.className,
              action: form.action,
              method: form.method
            });
          });

          // Log form validation errors
          form.addEventListener('invalid', function(event) {
            datadogUtils.warn('Form validation error', {
              field: event.target.name,
              formId: form.id || form.className,
              action: form.action
            });
          }, true);
        });

        // Log authentication-specific events
        const loginButton = document.querySelector('input[type="submit"][value*="Login"], button[type="submit"]');
        if (loginButton) {
          loginButton.addEventListener('click', function() {
            datadogUtils.trackEvent('login_attempt', {
              page: window.location.pathname
            });
          });
        }

        // Log password field interactions
        const passwordFields = document.querySelectorAll('input[type="password"]');
        passwordFields.forEach(function(field) {
          field.addEventListener('focus', function() {
            datadogUtils.trackEvent('password_field_focus', {
              fieldId: field.id || field.name,
              page: window.location.pathname
            });
          });
        });

        // Log error messages
        const errorElements = document.querySelectorAll('.alert-error, .error, [class*="error"]');
        errorElements.forEach(function(element) {
          if (element.textContent.trim()) {
            datadogUtils.error('FusionAuth UI Error', null, {
              errorMessage: element.textContent.trim(),
              page: window.location.pathname,
              elementClass: element.className
            });
          }
        });
      });
    </script>
[/#macro]

[#macro body]
<body class="app-sidebar-closed">
    [#-- Google Tag Manager (noscript) --]
    <noscript>
      <iframe
        src="https://www.googletagmanager.com/ns.html?id=${gtmID}"
        height="0" width="0" style="display:none;visibility:hidden">
      </iframe>
    </noscript>
    <!-- End Google Tag Manager (noscript) -->

<main class="flex flex-col h-screen">
  [#nested/]
</main>

<script>
  // Prevent pinch-to-zoom on iOS
  document.addEventListener('gesturestart', function(e) {
    e.preventDefault();
  });

  // Button loading state on form submit
  document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('form').forEach(function(form) {
      form.addEventListener('submit', function(e) {
        var submitBtn = form.querySelector('button[type="submit"], button:not([type])');
        if (submitBtn && !submitBtn.classList.contains('is-loading')) {
          submitBtn.classList.add('is-loading');
          submitBtn.disabled = true;
        }
      });
    });
  });
</script>
</body>
[/#macro]

[#macro header]
  <header class="relative flex items-center justify-center px-4 py-2 min-h-[56px]">
    <div class="logo-container flex justify-center w-full">
      <img src="https://images.ctfassets.net/c9t7ta4z3not/3F0gKIeZqKtMRUeDhBlN21/b7fcd6b9ed2dca6028100c6dcc29979f/centr-logo-black.svg?q=100&w=176" alt="Centr Logo" class="h-6 mx-auto my-auto">
    </div>
    <div class="right-menu absolute top-0 right-0 h-full flex items-center" [#if request.requestURI == "/"]style="display: block !important;" [/#if]>
      <nav>
        <ul class="flex h-full items-center">
          [#if request.requestURI == "/"]
            <li><a href="${request.contextPath}/admin/" title="Administrative login"><i class="fa fa-lock" style="font-size: 18px;"></i></a></li>
          [#elseif request.requestURI?starts_with("/account")]
            <li><a href="${request.contextPath}/account/logout?client_id=${client_id!''}" title="Logout"><i class="fa fa-sign-out"></i></a></li>
          [/#if]
        </ul>
      </nav>
    </div>
  </header>

  [#nested/]
[/#macro]

[#macro alternativeLoginsScript clientId identityProviders]
  [#if identityProviders["EpicGames"]?has_content || identityProviders["Facebook"]?has_content || identityProviders["Google"]?has_content ||
         identityProviders["LinkedIn"]?has_content || identityProviders["Nintendo"]?has_content || identityProviders["OpenIDConnect"]?has_content ||
         identityProviders["SAMLv2"]?has_content || identityProviders["SonyPSN"]?has_content || identityProviders["Steam"]?has_content ||
         identityProviders["Twitch"]?has_content || identityProviders["Xbox"]?has_content || identityProviders["Apple"]?has_content ||
         identityProviders["Twitter"]?has_content]
    [#-- Include Helper.js instead of loading dynamically from other IdP JS. IdP JS files will still load the script if it has not already been loaded --]
    <script id="idp_helper" src="${request.contextPath}/js/identityProvider/Helper.js?version=${version}"></script>
  [/#if]
  [#if identityProviders["Apple"]?has_content]
    <script src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"></script>
    <script src="${request.contextPath}/js/identityProvider/Apple.js?version=${version}"></script>
  [/#if]
  [#if identityProviders["Facebook"]?has_content]
    <script src="https://connect.facebook.net/en_US/sdk.js"></script>
    <script src="${request.contextPath}/js/identityProvider/Facebook.js?version=${version}" data-app-id="${identityProviders["Facebook"][0].lookupAppId(clientId)}"></script>
  [/#if]
  [#if identityProviders["Google"]?has_content && identityProviders["Google"][0].lookupLoginMethod(clientId) != "UseRedirect"]
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script src="${request.contextPath}/js/identityProvider/Google.js?version=${version}" data-client-id="${identityProviders["Google"][0].lookupClientId(clientId)}"></script>
  [/#if]
  [#if identityProviders["Twitter"]?has_content]
    [#-- This is the FusionAuth clientId --]
    <script src="${request.contextPath}/js/identityProvider/Twitter.js?version=${version}" data-client-id="${clientId}"></script>
  [/#if]
  [#if identityProviders["EpicGames"]?has_content || identityProviders["Facebook"]?has_content || identityProviders["Google"]?has_content ||
       identityProviders["LinkedIn"]?has_content || identityProviders["Nintendo"]?has_content || identityProviders["OpenIDConnect"]?has_content ||
       identityProviders["SAMLv2"]?has_content || identityProviders["SonyPSN"]?has_content || identityProviders["Steam"]?has_content ||
       identityProviders["Twitch"]?has_content || identityProviders["Xbox"]?has_content]
    <script src="${request.contextPath}/js/identityProvider/Redirect.js?version=${version}"></script>
  [/#if]
[/#macro]

[#macro main title="Login" subtitle=" " rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=false centerTitle=true showHeader=true titleClass=""]
[#if showCoverImage]
  <div class="flex flex-col md:flex-row md:flex-row-reverse h-screen">
    <!-- IMAGE FIRST -->
    <div class="w-full md:w-1/2 h-64 md:h-auto">
      <picture>
        <source srcset="https://images.ctfassets.net/c9t7ta4z3not/2NUE6hqPmhbhGqVJeHtlOy/86cdeaf81fe561f8cc711b31cfeed082/login-mobile.webp" media="(max-width: 767px)">
        <img src="https://images.ctfassets.net/c9t7ta4z3not/3ANSEf8mcY4VCIjOBO4unT/ba651e0ba916e44249cbc8a4f00190e0/login-desktop.webp" class="object-cover w-full h-full" alt="Cover image"/>
      </picture>
    </div>
    <!-- FORM SECOND -->
    <div class="w-full md:w-1/2 flex flex-col justify-center p-8">
      <div class="flex-grow flex flex-col w-full max-w-[520px] mx-auto" data-in-progress>
        [#if showHeader]
        <div class="hidden md:block">
          [@helpers.header]
            [#-- Custom header code goes here --]
          [/@helpers.header]
        </div>
        [/#if]
        <div class="flex flex-col items-start justify-center w-full gap-y-4 md:px-8 px-0">
          [#if title?has_content]
            [#if centerTitle]
              <h2 class="font-degular-black text-left py-4 ${titleClass}">${title}</h2>
            [#else]
              <h2 class="font-degular-black text-left self-start py-4 ${titleClass}">${title}</h2>
            [/#if]
          [/#if]
          [#if subtitle?has_content]
            <h3 class="font-suisseintl-regular text-left">${subtitle}</h3>
          [/#if]
        </div>
        [@printErrorAlerts rowClass colClass/]
        [@printInfoAlerts rowClass colClass/]
        <main class="card-body flex-grow !px-0 w-full">
          [#nested/]
        </main>
      </div>
    </div>
  </div>
[#else]
  <main class="flex flex-col flex-grow p-4">
    [@printErrorAlerts rowClass colClass/]
    [@printInfoAlerts rowClass colClass/]
      <div class="flex-grow flex flex-col w-full max-w-[520px] mx-auto gap-y-6" data-in-progress>
        <div class="flex flex-col items-start md:items-center justify-center w-full gap-y-4">
          [#if title?has_content]
            [#if centerTitle]
              <h2 class="font-degular-black text-left md:text-center py-4 ${titleClass}">${title}</h2>
            [#else]
              <h2 class="font-degular-black text-left self-start py-4 ${titleClass}">${title}</h2>
            [/#if]
          [/#if]
          [#if subtitle?has_content]
            <h3 class="font-suisseintl-regular${centerTitle?then(' text-left md:text-center','')}">${subtitle}</h3>
          [/#if]
        </div>
        <main class="!px-0 flex flex-col flex-grow w-full">
          [#nested/]
        </main>
      </div>
  </main>
[/#if]
[/#macro]

[#macro mainBoost title="Login" subtitle=" " rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=false centerTitle=true showHeader=true titleClass=""]
[#if showCoverImage]
  <div id="mainBoost" class="relative min-h-screen text-[color:white]">
    <!-- Full Background Cover Image -->
    <div class="absolute inset-0 z-0 vdb-cover-bg">
      <picture>
        <source srcset="https://images.ctfassets.net/c9t7ta4z3not/4gLXTDY0Jf49ZEpSi0MPWa/3b00a3991135b5167d686ba9b16dba96/Phone_Background_v2__1_.png" media="(max-width: 767px)">
        <source srcset="https://images.ctfassets.net/c9t7ta4z3not/7GLj0ZChymk3KGi7AgjQwn/5b03b8cb33f1d99ecba2a0f079796057/iPad_Background__Tablet_turf_768x1024_3x_v2__3_.png" media="(min-width: 768px) and (max-width: 1023px)">
        <source srcset="https://images.ctfassets.net/c9t7ta4z3not/5Kl7PZvW2mFcGXa0oHtglC/d2155f1be476c182cb3bc9a90823f6f4/desktop_background__med_opt.jpg" media="(min-width: 1024px)">
        <img src="https://images.ctfassets.net/c9t7ta4z3not/5Kl7PZvW2mFcGXa0oHtglC/d2155f1be476c182cb3bc9a90823f6f4/desktop_background__med_opt.jpg" class="object-cover w-full h-full" alt="Cover image"/>
      </picture>
    </div>

    <!-- Content Overlay -->
    <div class="relative z-10 min-h-screen flex flex-col justify-start items-center p-4 md:p-8">
      <div class="flex flex-col w-full max-w-[520px] mx-auto" data-in-progress>
        [#if showHeader]
        <div class="hidden md:block">
          [@helpers.header]
            [#-- Custom header code goes here --]
          [/@helpers.header]
        </div>
        [/#if]
        <div class="flex flex-col items-start justify-center w-full gap-y-4 px-0">
          [#if title?has_content]
            [#if centerTitle]
              <h2 class="font-degular-black text-left py-4 ${titleClass}">${title}</h2>
            [#else]
              <h2 class="font-degular-black text-left self-start py-4 ${titleClass}">${title}</h2>
            [/#if]
          [/#if]
          [#if subtitle?has_content]
            <h3 class="font-suisseintl-regular text-left">${subtitle}</h3>
          [/#if]
        </div>
        [@printErrorAlerts rowClass colClass/]
        [@printInfoAlerts rowClass colClass/]
        <main class="card-body flex-grow !px-0 w-full">
          [#nested/]
        </main>
      </div>
    </div>
  </div>
[#else]
  <main class="flex flex-col flex-grow p-4">
    [@printErrorAlerts rowClass colClass/]
    [@printInfoAlerts rowClass colClass/]
      <div class="flex-grow flex flex-col w-full max-w-[520px] mx-auto gap-y-6" data-in-progress>
        <div class="flex flex-col items-start md:items-center justify-center w-full gap-y-4">
          [#if title?has_content]
            [#if centerTitle]
              <h2 class="font-degular-black text-left md:text-center py-4">${title}</h2>
            [#else]
              <h2 class="font-degular-black text-left self-start py-4">${title}</h2>
            [/#if]
          [/#if]
          [#if subtitle?has_content]
            <h3 class="font-suisseintl-regular${centerTitle?then(' text-left md:text-center','')}">${subtitle}</h3>
          [/#if]
        </div>
        <main class="!px-0 flex flex-col flex-grow w-full">
          [#nested/]
        </main>
      </div>
  </main>
[/#if]
[/#macro]

[#-- Rebranded auth card layout (current rebrand). Full-bleed cover (image or
     video) with a centered dark card. mode="split" renders a two-column
     layout with a marketing-copy column and a Sign In / Create Account tab
     switcher (used by oauth2Authorize.ftl / oauth2Register.ftl). mode="single"
     renders just the card with [#nested/] content (used by passwordForgot.ftl,
     registrationComplete.ftl, and other simple pages). See CONTEXT.md for the
     previous-vs-current rebrand notes. --]
[#macro authCard
    mode="single"
    activeTab=""
    coverImageDesktop="https://images.ctfassets.net/c9t7ta4z3not/5Kl7PZvW2mFcGXa0oHtglC/d2155f1be476c182cb3bc9a90823f6f4/desktop_background__med_opt.jpg"
    coverImageTablet="https://images.ctfassets.net/c9t7ta4z3not/7GLj0ZChymk3KGi7AgjQwn/5b03b8cb33f1d99ecba2a0f079796057/iPad_Background__Tablet_turf_768x1024_3x_v2__3_.png"
    coverImageMobile="https://images.ctfassets.net/c9t7ta4z3not/4gLXTDY0Jf49ZEpSi0MPWa/3b00a3991135b5167d686ba9b16dba96/Phone_Background_v2__1_.png"
    coverVideoUrl="https://cdn.shopify.com/videos/c/o/v/9f3b0d7732bc4124abc41f91c9224c7c.mp4"
    coverVideoPoster=""
    eyebrow=""
    headingLine1=""
    headingLine2=""
    description=""]
<div class="authcard-page">
  <!-- Full Background Cover -->
  <div class="authcard-bg">
    [#if coverVideoUrl?has_content]
      <video autoplay loop muted playsinline [#if coverVideoPoster?has_content]poster="${coverVideoPoster}"[/#if]>
        <source src="${coverVideoUrl}" type="video/mp4">
      </video>
    [#else]
      <picture>
        [#if coverImageMobile?has_content]<source srcset="${coverImageMobile}" media="(max-width: 767px)">[/#if]
        [#if coverImageTablet?has_content]<source srcset="${coverImageTablet}" media="(min-width: 768px) and (max-width: 1023px)">[/#if]
        <img src="${coverImageDesktop}" alt="Cover image"/>
      </picture>
    [/#if]
  </div>

  <!-- Content -->
  <div class="authcard-content">
    <div class="authcard-card authcard-${mode}" data-in-progress>
      [#if mode == "split"]
        <div class="authcard-marketing">
          [#if eyebrow?has_content]
            <span class="authcard-eyebrow">${eyebrow}</span>
          [/#if]
          [#if headingLine1?has_content || headingLine2?has_content]
            <h1 class="authcard-heading">
              [#if headingLine1?has_content]<span class="block">${headingLine1}</span>[/#if]
              [#if headingLine2?has_content]<span class="block text-yellow">${headingLine2}</span>[/#if]
            </h1>
          [/#if]
          [#if description?has_content]
            <p class="authcard-description">${description}</p>
          [/#if]
        </div>
        <div class="authcard-form">
          <div class="authcard-tabs">
            [@link url="/oauth2/authorize" class="authcard-tab${(activeTab == 'signin')?then(' authcard-tab-active', '')}"]${theme.message('authcard-tab-sign-in')}[/@link]
            [@link url="/oauth2/register" class="authcard-tab${(activeTab == 'register')?then(' authcard-tab-active', '')}"]${theme.message('authcard-tab-create-account')}[/@link]
          </div>
          [@printErrorAlerts rowClass="" colClass="w-full"/]
          [@printInfoAlerts rowClass="" colClass="w-full"/]
          [#nested/]
        </div>
      [#else]
        <div class="authcard-form">
          [@printErrorAlerts rowClass="" colClass="w-full"/]
          [@printInfoAlerts rowClass="" colClass="w-full"/]
          [#nested/]
        </div>
      [/#if]
    </div>
  </div>
</div>
[/#macro]

[#macro accountMain rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" actionURL="" actionText="Go back" actionDirection="back"]
<main class="page-body container">
  [@printErrorAlerts rowClass colClass/]
  [@printInfoAlerts rowClass colClass/]
  <div class="w-full h-full mx-auto flex flex-col justify-center bg-transparent" style="max-width: 520px!important;">
    <div class="${colClass}">
      [#nested/]
    </div>
  </div>
  [@accountFooter rowClass "col-xs-6 col-sm-6 col-md-5 col-lg-4" actionURL actionText actionDirection/]
</main>
[/#macro]

[#macro localSelector]
<label class="select">
  <select id="locale-select" name="locale" class="select">
    <option value="en" [#if locale == 'en']selected[/#if]>English</option>
      [#list theme.additionalLocales() as l]
        <option value="${l}" [#if locale == l]selected[/#if]>${l.getDisplayLanguage(locale)}</option>
      [/#list]
  </select>
</label>
[/#macro]

[#macro accountFooter rowClass colClass actionURL actionText actionDirection]
<div class="${rowClass}">
  <div class="${colClass}" style="text-align: right;">

  [#-- actionURL and actionText may be an array. For backwards compatibility, allow a string
       or an array. If not an array yet, convert to one now. --]
  [#if !actionURL?is_sequence]
    [#local actionURLs = [actionURL]/]
  [#else]
    [#local actionURLs = actionURL/]
  [/#if]

  [#if !actionText?is_sequence]
    [#local actionTexts = [actionText]/]
  [#else]
    [#local actionTexts = actionText/]
  [/#if]

  [#list actionURLs as url]
    [#local actionURL = url/]
    [#if actionURL?has_content]
      [#if !actionURL?contains("client_id")]
        [#if actionURL?contains("?")]
         [#local actionURL = actionURL + "&client_id=${client_id}"/]
        [#else]
         [#local actionURL = actionURL + "?client_id=${client_id}"/]
        [/#if]
      [/#if]
      [#if actionDirection == "back"]
        <a href="${actionURL}"> <i class="fa fa-arrow-left"></i> ${actionTexts[url_index]}</a>
      [#else]
        <a class="d-inline-block mb-2" href="${actionURL}">${actionTexts[url_index]} <i class="fa fa-arrow-right"></i></a>
      [/#if]
      [#sep]<br>[/#sep]
    [/#if]
  [/#list]
  </div>
</div>
[/#macro]

[#macro accountPanelFull title=""]
<div class="panel">
  [#if title?has_content]
    <h2>${title}</h2>
  [/#if]
  <main>
    [#nested/]
  </main>
</div>
[/#macro]

[#macro accountPanel title tenant user action showEdit]
<div class="panel">
  [#if title?has_content]
    <h2>${title}</h2>
  [/#if]
  <main>
   <div class="row mb-5 user-details">
      [#-- Column 1 --]
      <div class="col-xs-12 col-md-4 col-lg-4 tight-left" style="padding-bottom: 0;">
        <div class="avatar pr-2 pb-3">
          <div>
            [#if user.imageUrl??]
              <img src="${user.imageUrl}" class="profile w-100" alt="profile image"/>
            [#elseif user.lookupEmail()??]
              <img src="${function.gravatar(user.lookupEmail(), 200)}" class="profile w-100" alt="profile image"/>
            [#else]
              <img src="${request.contextPath}/images/missing-user-image.svg" class="profile w-100" alt="profile image"/>
            [/#if]
          </div>
          <div>${display(user, "name")}</div>
       </div>
      </div>
      [#-- Column 2 --]
      <div class="col-xs-12 col-md-8 col-lg-8 tight-left">
        [#nested/]
      </div>
      [#if action == "view"]
        <div class="panel-actions">
         <div class="status">
           [#if showEdit]
            <a id="edit-profile" class="blue icon" href="${request.contextPath}/account/edit?client_id=${client_id}">
              <span style="font-size: 0.9rem;">
              <i class="fa fa-pencil blue-text" data-tooltip="${theme.message('edit-profile')}"></i>
              </span>
            </a>
           [/#if]
         </div>
       </div>
      [/#if]
  </div>
  </main>
</div>
[/#macro]

[#macro footer]
  [#nested/]
[/#macro]

[#-- Below are the social login buttons and helpers --]
[#macro appleButton identityProvider clientId]
 <button type="button" id="apple-login-button" class="apple login-button w-full flex items-center justify-center gap-3 vdb-social-btn p-2.5 cursor-pointer" data-scope="${identityProvider.lookupScope(clientId)!''}" data-services-id="${identityProvider.lookupServicesId(clientId)}" data-identity-provider-id="${identityProvider.id}">
   CONTINUE WITH APPLE
 </button>
[/#macro]

[#macro facebookButton identityProvider clientId]
 <button type="button" id="facebook-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="${identityProvider.lookupLoginMethod(clientId)!''}" data-permissions="${identityProvider.lookupPermissions(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
   <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
     <path d="M22 12.0611C22 6.50451 17.5229 2 12 2C6.47715 2 2 6.50451 2 12.0611C2 17.0828 5.65684 21.2452 10.4375 22V14.9694H7.89844V12.0611H10.4375V9.84452C10.4375 7.32296 11.9305 5.93012 14.2146 5.93012C15.3088 5.93012 16.4531 6.12663 16.4531 6.12663V8.60261H15.1922C13.95 8.60261 13.5625 9.37822 13.5625 10.1739V12.0611H16.3359L15.8926 14.9694H13.5625V22C18.3432 21.2452 22 17.0828 22 12.0611Z" fill="#2F2C2C"/>
   </svg>
  <span class="text">Continue with Facebook</span>
 </button>
[/#macro]

[#macro googleButton identityProvider clientId idpRedirectState=""]
  [#-- When using this loginMethod - the Google JavaScript API is not used at all. --]
  [#if identityProvider.lookupLoginMethod(clientId) == "UseRedirect"]
    <button type="button" id="google-login-button" class="w-full flex items-center justify-center gap-3 vdb-social-btn p-2.5 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
      CONTINUE WITH GOOGLE
    </button>
  [#else] [#-- UsePopup or UseVendorJavaScript --]
    [#--
     Use the Google Identity Service (GIS) API.
     https://developers.google.com/identity/gsi/web/reference/html-reference
    --]
    <div id="g_id_onload" [#list identityProvider.lookupAPIProperties(clientId)!{} as attribute, value] data-${attribute}="${value}" [/#list]
         data-client_id="${identityProvider.lookupClientId(clientId)}"
         data-login_uri="${currentBaseURL}/oauth2/callback?state=${idpRedirectState}&identityProviderId=${identityProvider.id}" >
    </div>
    [#-- This the Google Signin button. If only using One tap, you can delete or commment out this element --]
    <div class="g_id_signin" [#list identityProvider.lookupButtonProperties(clientId)!{} as attribute, value] data-${attribute}="${value}" [/#list]
         [#-- Optional click handler, when using ux_mode=popup. --]
         data-click_listener="googleButtonClickHandler" >
    </div>
  [/#if]
[/#macro]

[#macro linkedInBottom identityProvider clientId]
 <button type="button" id="linkedin-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-identity-provider-id="${identityProvider.id}">
   <div>
     <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
   </div>
 </button>
[/#macro]

[#macro nintendoButton identityProvider clientId]
<button type="button" id="nintendo-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
  <div>
    <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
  </div>
</button>
[/#macro]

[#macro twitterButton identityProvider clientId]
 <button type="button" id="twitter-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer">
   <div>
     <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
   </div>
 </button>
[/#macro]

[#macro openIDConnectButton identityProvider clientId]
 <button type="button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50" data-login-method="UseRedirect" data-identity-provider-id="${identityProvider.id}">
   <div>
     <div class="icon">
       [#if identityProvider.lookupButtonImageURL(clientId)?has_content]
         <img src="${identityProvider.lookupButtonImageURL(clientId)}" title="OpenID Connect Logo" alt="OpenID Connect Logo"/>
       [#else]
         <svg version="1.1" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
           <g id="g2189">
             <g id="g2202">
               <path class="cls-1" d="M87.57,39.57c-8.9-5.55-21.38-9-34.95-9C25.18,30.59,3,44.31,3,61.17,3,76.64,21.46,89.34,45.46,91.52v-8.9c-16.12-2-28.24-10.87-28.24-21.45,0-12,15.84-21.9,35.4-21.9,9.78,0,18.6,2.41,24.95,6.43l-9,5.62H96.84V33.8Z"></path>
               <path class="cls-2" d="M45.46,15.41v76l14.23-8.9V6.22Z"></path>
             </g>
           </g>
         </svg>
       [/#if]
     </div>
     <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
   </div>
 </button>
[/#macro]

[#macro samlv2Button identityProvider clientId]
 <button type="button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50" data-login-method="UseRedirect" data-identity-provider-id="${identityProvider.id}">
   <div>
     <div class="icon">
       [#if identityProvider.lookupButtonImageURL(clientId)?has_content]
         <img src="${identityProvider.lookupButtonImageURL(clientId)}" title="SAML Login" alt="SAML Login"/>
       [#else]
         <img src="/images/identityProviders/samlv2.svg" title="SAML 2 Logo" alt="SAML 2 Logo"/>
       [/#if]
     </div>
     <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
   </div>
 </button>
[/#macro]

[#macro sonypsnButton identityProvider clientId]
<button type="button" id="sonypsn-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
  <div>
    <div class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="-6.003495 -7.75 52.03029 46.5">
        <path fill="#0070d1" d="M.81 22.6c-1.5 1-1 2.9 2.2 3.8 3.3 1.1 6.9 1.4 10.4.8.2 0 .4-.1.5-.1v-3.4l-3.4 1.1c-1.3.4-2.6.5-3.9.2-1-.3-.8-.9.4-1.4l6.9-2.4v-3.7l-9.6 3.3c-1.2.4-2.4 1-3.5 1.8zm23.2-15v9.7c4.1 2 7.3 0 7.3-5.2 0-5.3-1.9-7.7-7.4-9.6-2.9-1-5.9-1.9-8.9-2.5v28.9l7 2.1V6.7c0-1.1 0-1.9.8-1.6 1.1.3 1.2 1.4 1.2 2.5zm13 12.7c-2.9-1-6-1.4-9-1.1-1.6.1-3.1.5-4.5 1l-.3.1v3.9l6.5-2.4c1.3-.4 2.6-.5 3.9-.2 1 .3.8.9-.4 1.4l-10 3.7v3.8l13.8-5.1c1-.4 1.9-.9 2.7-1.7.7-1 .4-2.4-2.7-3.4z"/>
      </svg>
    </div>
    <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
  </div>
</button>
[/#macro]

[#macro steamButton identityProvider clientId]
<button type="button" id="steam-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
  <div>
    <div class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 233 233">
       <defs>
        <linearGradient id="a" x2="50%" x1="50%" y2="100%">
         <stop stop-color="#111D2E" offset="0"/>
         <stop stop-color="#051839" offset=".21248"/>
         <stop stop-color="#0A1B48" offset=".40695"/>
         <stop stop-color="#132E62" offset=".58110"/>
         <stop stop-color="#144B7E" offset=".73760"/>
         <stop stop-color="#136497" offset=".87279"/>
         <stop stop-color="#1387B8" offset="1"/>
        </linearGradient>
       </defs>
       <path fill="url(#a)" d="m4.8911 150.01c14.393 48.01 58.916 82.99 111.61 82.99 64.34 0 116.5-52.16 116.5-116.5 0-64.341-52.16-116.5-116.5-116.5-61.741 0-112.26 48.029-116.25 108.76 7.5391 12.66 10.481 20.49 4.6411 41.25z"/>
       <path fill="#fff" d="m110.5 87.322c0 0.196 0 0.392 0.01 0.576l-28.508 41.412c-4.618-0.21-9.252 0.6-13.646 2.41-1.937 0.79-3.752 1.76-5.455 2.88l-62.599-25.77c0.00049 0-1.4485 23.83 4.588 41.59l44.254 18.26c2.222 9.93 9.034 18.64 19.084 22.83 16.443 6.87 35.402-0.96 42.242-17.41 1.78-4.3 2.61-8.81 2.49-13.31l40.79-29.15c0.33 0.01 0.67 0.02 1 0.02 24.41 0 44.25-19.9 44.25-44.338 0-24.44-19.84-44.322-44.25-44.322-24.4 0-44.25 19.882-44.25 44.322zm-6.84 83.918c-5.294 12.71-19.9 18.74-32.596 13.45-5.857-2.44-10.279-6.91-12.83-12.24l14.405 5.97c9.363 3.9 20.105-0.54 23.997-9.9 3.904-9.37-0.525-20.13-9.883-24.03l-14.891-6.17c5.746-2.18 12.278-2.26 18.381 0.28 6.153 2.56 10.927 7.38 13.457 13.54s2.52 12.96-0.04 19.1m51.09-54.38c-16.25 0-29.48-13.25-29.48-29.538 0-16.275 13.23-29.529 29.48-29.529 16.26 0 29.49 13.254 29.49 29.529 0 16.288-13.23 29.538-29.49 29.538m-22.09-29.583c0-12.253 9.92-22.191 22.14-22.191 12.23 0 22.15 9.938 22.15 22.191 0 12.254-9.92 22.183-22.15 22.183-12.22 0-22.14-9.929-22.14-22.183z"/>
      </svg>
    </div>
    <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
  </div>
</button>
[/#macro]

[#macro twitchButton identityProvider clientId]
<button type="button" id="twitch-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
  <div>
    <div class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2400 2800">
        <g>
          <polygon fill="#FFFFFF" points="2200,1300 1800,1700 1400,1700 1050,2050 1050,1700 600,1700 600,200 2200,200"/>
          <g>
            <g fill="#9146FF">
              <path d="M500,0L0,500v1800h600v500l500-500h400l900-900V0H500z M2200,1300l-400,400h-400l-350,350v-350H600V200h1600 V1300z"/>
              <rect x="1700" y="550" width="200" height="600"/>
              <rect x="1150" y="550" width="200" height="600"/>
            </g>
          </g>
        </g>
      </svg>
    </div>
    <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
  </div>
</button>
[/#macro]

[#macro xboxButton identityProvider clientId]
<button type="button" id="xbox-login-button" class="flex-1 flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50 cursor-pointer" data-login-method="UseRedirect" data-scope="${identityProvider.lookupScope(clientId)!''}" data-identity-provider-id="${identityProvider.id}">
  <div>
    <div class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="-12.90591 -21.521775 111.85122 129.13065">
        <path d="M38.7297 85.9103c-6.628-.635-13.338-3.015-19.102-6.776-4.83-3.15-5.92-4.447-5.92-7.032 0-5.193 5.71-14.29 15.48-24.658 5.547-5.89 13.275-12.79 14.11-12.604 1.626.363 14.616 13.034 19.48 19 7.69 9.43 11.224 17.154 9.428 20.597-1.365 2.617-9.837 7.733-16.06 9.698-5.13 1.62-11.867 2.306-17.416 1.775zm-31.546-19.207c-4.014-6.158-6.042-12.22-7.02-20.988-.324-2.895-.21-4.55.733-10.494 1.173-7.4 5.39-15.97 10.46-21.24 2.158-2.24 2.35-2.3 4.982-1.41 3.19 1.08 6.6 3.436 11.89 8.22l3.09 2.794-1.69 2.07c-7.828 9.61-16.09 23.24-19.2 31.67-1.69 4.58-2.37 9.18-1.64 11.095.49 1.294.04.812-1.61-1.714zm70.453 1.047c.397-1.936-.105-5.49-1.28-9.076-2.545-7.765-11.054-22.21-18.867-32.032l-2.46-3.092 2.662-2.443c3.474-3.19 5.886-5.1 8.49-6.723 2.053-1.28 4.988-2.413 6.25-2.413.777 0 3.516 2.85 5.726 5.95 3.424 4.8 5.942 10.63 7.218 16.69.825 3.92.894 12.3.133 16.21-.63 3.208-1.95 7.366-3.23 10.187-.97 2.113-3.36 6.218-4.41 7.554-.54.687-.54.686-.24-.796zm-38.197-57.245c-3.606-1.83-9.168-3.795-12.24-4.325-1.076-.185-2.913-.29-4.08-.23-2.536.128-2.423-.004 1.643-1.925 3.38-1.597 6.2-2.536 10.03-3.34 4.305-.905 12.4-.915 16.637-.022 4.575.965 9.964 2.97 13 4.84l.904.554-2.07-.104c-4.116-.208-10.114 1.455-16.554 4.587-1.942.946-3.63 1.7-3.754 1.68-.123-.024-1.706-.795-3.52-1.715z" fill="#107c10"/>
      </svg>
    </div>
    <div class="text">${identityProvider.lookupButtonText(clientId)?trim}</div>
  </div>
</button>
[/#macro]

[#macro alternativeLogins clientId identityProviders passwordlessEnabled bootstrapWebauthnEnabled=false idpRedirectState="" federatedCSRFToken="" showOrDivider=false]
  [#if identityProviders?has_content || passwordlessEnabled || bootstrapWebauthnEnabled]
    <div id="login-button-container" class="login-button-container" data-federated-csrf="${federatedCSRFToken}">
      [#if passwordlessEnabled]
        <div class="w-full mb-4 hidden">
          [@link url = "/oauth2/passwordless"]
            <button class="w-full flex items-center justify-center gap-2 btn-border-custom btn-alt-login rounded-lg h-12 hover:bg-gray-50">
              <span class="icon"><i class="fa fa-link"></i></span>
              <span class="text">${theme.message('passwordless-button-text')}</span>
            </button>
          [/@link]
        </div>
      [/#if]

      [#if bootstrapWebauthnEnabled]
      <div class="form-row push-less-top">
        [@link url = "/oauth2/webauthn"]
          <div class="magic login-button">
            <div>
              <div class="icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="512.000000pt" height="512.000000pt" viewBox="0 0 512.000000 512.000000" preserveAspectRatio="xMidYMid meet">
                  <g transform="translate(0.000000,512.000000) scale(0.100000,-0.100000)" fill="#FFF" stroke="none">
                    <path d="M923 4595 c-187 -51 -349 -214 -398 -402 -12 -44 -15 -122 -15 -348 0 -261 2 -294 19 -331 51 -112 193 -135 276 -43 19 21 37 49 40 61 2 13 6 160 7 328 3 338 5 345 72 386 28 17 58 19 336 22 168 1 315 5 328 7 12 3 40 21 61 40 92 83 69 225 -43 276 -37 17 -70 19 -336 18 -221 0 -308 -4 -347 -14z"/>
                    <path d="M3514 4591 c-112 -51 -135 -193 -43 -276 21 -19 49 -37 61 -40 13 -2 160 -6 328 -7 338 -3 345 -5 386 -72 17 -28 19 -58 22 -336 1 -168 5 -315 7 -328 3 -12 21 -40 40 -61 83 -92 225 -69 276 43 17 37 19 70 19 331 0 320 -5 355 -61 468 -42 82 -154 194 -236 236 -113 56 -148 61 -468 61 -261 0 -294 -2 -331 -19z"/>
                    <path d="M1640 3229 c-14 -6 -36 -20 -48 -32 -49 -46 -52 -62 -52 -294 0 -193 2 -222 19 -253 48 -91 175 -117 252 -53 61 51 69 86 69 298 0 105 -4 206 -10 224 -11 39 -51 86 -92 107 -31 16 -101 17 -138 3z"/>
                    <path d="M2500 3233 c-36 -15 -72 -48 -90 -83 -19 -37 -20 -60 -20 -398 l0 -359 -31 -7 c-79 -15 -139 -89 -139 -170 0 -48 31 -109 72 -138 47 -33 153 -33 220 0 70 35 140 103 179 174 l34 63 3 397 c3 382 2 399 -17 437 -30 57 -73 84 -140 88 -31 1 -63 0 -71 -4z"/>
                    <path d="M3335 3222 c-44 -29 -74 -65 -85 -103 -6 -19 -10 -119 -10 -224 0 -212 8 -247 69 -298 77 -64 204 -38 252 53 17 31 19 60 19 256 0 213 -1 222 -22 254 -37 54 -71 73 -135 77 -45 3 -65 0 -88 -15z"/>
                    <path d="M2006 1870 c-34 -11 -82 -54 -102 -92 -19 -37 -18 -106 4 -148 34 -69 212 -173 387 -226 84 -26 102 -28 265 -28 163 0 181 2 265 28 175 53 353 157 387 226 70 139 -75 297 -213 231 -24 -11 -72 -38 -107 -60 -99 -62 -169 -83 -302 -88 -165 -7 -265 22 -421 122 -60 39 -114 50 -163 35z"/>
                    <path d="M627 1696 c-50 -18 -76 -42 -98 -91 -17 -36 -19 -70 -19 -330 0 -320 5 -355 61 -468 42 -82 154 -194 236 -236 113 -56 148 -61 468 -61 261 0 294 2 331 19 112 51 135 193 43 276 -21 19 -49 37 -61 40 -13 2 -160 6 -328 7 -435 4 -403 -29 -410 423 -3 217 -9 326 -17 340 -19 33 -66 72 -102 84 -43 14 -57 13 -104 -3z"/>
                    <path d="M4385 1698 c-33 -11 -80 -51 -98 -83 -8 -14 -14 -123 -17 -340 -7 -452 25 -419 -410 -423 -168 -1 -315 -5 -328 -7 -12 -3 -40 -21 -61 -40 -92 -83 -69 -225 43 -276 37 -17 70 -19 331 -19 320 0 355 5 468 61 82 42 194 154 236 236 56 113 61 148 61 468 0 260 -2 294 -19 330 -22 49 -48 73 -98 91 -45 16 -67 16 -108 2z"/>
                  </g>
                </svg>
              </div>
              <div class="text">${theme.message('webauthn-button-text')}</div>
            </div>
          </div>
        [/@link]
      </div>
      [/#if]

      <div class="grid grid-cols-1 gap-3 lg:grid-cols-2">
        [#if identityProviders["Google"]?has_content]
          [@googleButton identityProvider=identityProviders["Google"][0] clientId=clientId idpRedirectState=idpRedirectState/]
        [/#if]

        [#if identityProviders["Facebook"]?has_content]
          [@facebookButton identityProvider=identityProviders["Facebook"][0] clientId=clientId /]
        [/#if]

        [#if identityProviders["Apple"]?has_content]
          [@appleButton identityProvider=identityProviders["Apple"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["EpicGames"]?has_content]
          [@epicButton identityProvider=identityProviders["EpicGames"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["LinkedIn"]?has_content]
          [@linkedInBottom identityProvider=identityProviders["LinkedIn"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["Nintendo"]?has_content]    
          [@nintendoButton identityProvider=identityProviders["Nintendo"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["OpenIDConnect"]?has_content]
          [#list identityProviders["OpenIDConnect"] as identityProvider]
              [@openIDConnectButton identityProvider=identityProvider clientId=clientId/]
          [/#list]
        [/#if]

        [#if identityProviders["SAMLv2"]?has_content]
          [#list identityProviders["SAMLv2"] as identityProvider]
              [@samlv2Button identityProvider=identityProvider clientId=clientId/]
          [/#list]
        [/#if]

        [#if identityProviders["SonyPSN"]?has_content]
            [@sonypsnButton identityProvider=identityProviders["SonyPSN"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["Steam"]?has_content]
            [@steamButton identityProvider=identityProviders["Steam"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["Twitch"]?has_content]
            [@twitchButton identityProvider=identityProviders["Twitch"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["Twitter"]?has_content]
          [@twitterButton identityProvider=identityProviders["Twitter"][0] clientId=clientId/]
        [/#if]

        [#if identityProviders["Xbox"]?has_content]
          [@xboxButton identityProvider=identityProviders["Xbox"][0] clientId=clientId/]
        [/#if]

      </div>

    </div>
  [/#if]
[/#macro]

[#-- Below are the helpers for errors and alerts --]

[#macro printErrorAlerts rowClass colClass]
  [#if errorMessages?size > 0]
    [#list errorMessages as m]
      [@alert message=m type="error" icon="exclamation-circle" rowClass=rowClass colClass=colClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro printInfoAlerts rowClass colClass]
  [#if infoMessages?size > 0]
    [#list infoMessages as m]
      [@alert message=m type="info" icon="info-circle" rowClass=rowClass colClass=colClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro alert message type icon includeDismissButton=true rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
<div class="${rowClass}">
  <div class="${colClass}">
    <div class="alert ${type}">
      <i class="fa fa-${icon}"></i>
      <p>
        ${message}
      </p>
      [#if includeDismissButton]
        <a href="#" class="dismiss-button"><i class="fa fa-times-circle"></i></a>
      [/#if]
    </div>
  </div>
</div>
[/#macro]

[#-- Below are the input helpers for hidden, text, buttons, labels and form errors.
     These fields are general purpose and can be used on any form you like. --]

[#-- Hidden Input --]
[#macro hidden name value="" dateTimeFormat=""]
  [#if !value?has_content]
    [#local value=("((" + name + ")!'')")?eval?string/]
  [/#if]
  <input type="hidden" name="${name}" [#if value == ""]value="${value}" [#else]value="${value?string}"[/#if]/>
  [#if dateTimeFormat != ""]
  <input type="hidden" name="${name}@dateTimeFormat" value="${dateTimeFormat}"/>
  [/#if]
[/#macro]

[#-- Input field of type. --]
[#macro input type name id class autocapitalize="none" autocomplete="on" autocorrect="off" autofocus=false spellcheck="false" label="" placeholder="" leftAddon="" required=false tooltip="" disabled=false class="" dateTimeFormat="" value="" uncheckedValue=""]
<div class="form-row ${class}">
  [#if type == "checkbox"]
    [@_input_checkbox name=name value=value uncheckedValue=uncheckedValue label=label tooltip=tooltip required=required id=id]
     [#nested]
    [/@_input_checkbox]
  [#else]
    [@_input_text type=type name=name id=id autocapitalize=autocapitalize autocomplete=autocomplete autocorrect=autocorrect autofocus=autofocus spellcheck=spellcheck label=label placeholder=placeholder leftAddon=leftAddon required=required tooltip=tooltip disabled=disabled class=class dateTimeFormat=dateTimeFormat/]
  [/#if]
  [@errors field=name/]
</div>
[/#macro]

[#macro _input_text type name id autocapitalize autocomplete autocorrect autofocus spellcheck label placeholder leftAddon required tooltip disabled class dateTimeFormat ]
  <label for="${id}"
    class="block mb-1 font-medium text-base label-suisseintl-book
      [#if (fieldMessages[name]![])?size > 0] text-error [#else] text-gray-700 [/#if]
    ">
    ${label!name}
    [#if required] <span class="text-error">*</span>[/#if]
    [#if tooltip?has_content]
      <i class="fa fa-info-circle ml-1 text-info" data-tooltip="${tooltip}"></i>
    [/#if]
  </label>
  [#if leftAddon?has_content && leftAddon != "none"]
  <div class="flex items-center input-group mb-2">
    <span class="input-addon bg-base-200 px-3 py-2 rounded-l border border-r-0 border-base-300 text-base-content">
      <i class="fa fa-${leftAddon}"></i>
    </span>
  [/#if]
  [#local value=((("((" + name + ")!'')")?eval))]
  [#if type == "password"]
    <div class="flex items-center relative h-12">
      <input
        id="${id}"
        type="password"
        name="${name}"
        placeholder="${placeholder?has_content?then(placeholder, label)}"
        class="input input-bordered w-full h-12
          [#if leftAddon?has_content && leftAddon != "none"] rounded-l-none [/#if]
          [#if (fieldMessages[name]![])?size > 0] input-error [/#if]
          focus:outline-none focus:ring-0
          ${class}
        "
        autocapitalize="${autocapitalize}"
        autocomplete="${autocomplete}"
        autocorrect="${autocorrect}"
        spellcheck="${spellcheck}"
        [#if autofocus]autofocus="autofocus"[/#if]
        [#if disabled]disabled="disabled"[/#if]
      />
      <button type="button" class="absolute right-2 flex items-center justify-center rounded-full w-8 h-8 p-0 border-none bg-transparent shadow-none z-10 password-toggle-btn cursor-pointer" aria-label="Toggle password visibility" onclick="togglePassword('${id}', this)">
        <span class="icon-show">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M3.8806 12C6.14365 15.584 8.85254 17.25 12 17.25C15.1475 17.25 17.8564 15.584 20.1194 12C17.8564 8.41604 15.1475 6.75 12 6.75C8.85254 6.75 6.14365 8.41604 3.8806 12ZM2.35688 11.6141C4.84664 7.46452 8.05833 5.25 12 5.25C15.9417 5.25 19.1534 7.46452 21.6431 11.6141C21.7856 11.8516 21.7856 12.1484 21.6431 12.3859C19.1534 16.5355 15.9417 18.75 12 18.75C8.05833 18.75 4.84664 16.5355 2.35688 12.3859C2.21437 12.1484 2.21437 11.8516 2.35688 11.6141ZM10.0555 10.0555C10.5712 9.53973 11.2707 9.25 12 9.25C12.7293 9.25 13.4288 9.53973 13.9445 10.0555C14.4603 10.5712 14.75 11.2707 14.75 12C14.75 12.7293 14.4603 13.4288 13.9445 13.9445C13.4288 14.4603 12.7293 14.75 12 14.75C11.2707 14.75 10.5712 14.4603 10.0555 13.9445C9.53973 13.4288 9.25 12.7293 9.25 12C9.25 11.2707 9.53973 10.5712 10.0555 10.0555ZM12 10.75C11.6685 10.75 11.3505 10.8817 11.1161 11.1161C10.8817 11.3505 10.75 11.6685 10.75 12C10.75 12.3315 10.8817 12.6495 11.1161 12.8839C11.3505 13.1183 11.6685 13.25 12 13.25C12.3315 13.25 12.6495 13.1183 12.8839 12.8839C13.1183 12.6495 13.25 12.3315 13.25 12C13.25 11.6685 13.1183 11.3505 12.8839 11.1161C12.6495 10.8817 12.3315 10.75 12 10.75Z" fill="#2F2C2C"/>
          </svg>
        </span>
        <span class="icon-hide" style="display:none;">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M2.21967 2.21967C2.51256 1.92678 2.98744 1.92678 3.28033 2.21967L16.8912 15.8305C16.9395 15.868 16.9838 15.912 17.0227 15.962L21.2803 20.2197C21.5732 20.5126 21.5732 20.9874 21.2803 21.2803C20.9874 21.5732 20.5126 21.5732 20.2197 21.2803L16.3037 17.3644C14.9073 18.118 13.3407 18.5101 11.7475 18.5C7.80698 18.4991 4.59612 16.2846 2.10688 12.1359C1.96437 11.8984 1.96437 11.6016 2.10688 11.3641C3.22369 9.50278 4.48592 8.02627 5.90414 6.9648L2.21967 3.28033C1.92678 2.98744 1.92678 2.51256 2.21967 2.21967ZM6.9775 8.03816C5.77763 8.8941 4.65876 10.1221 3.63061 11.75C5.89366 15.334 8.60254 17 11.75 17H11.7549V17C12.9447 17.0079 14.117 16.7492 15.1872 16.2478L13.091 14.1517C12.6847 14.3787 12.2237 14.501 11.75 14.5011C11.0206 14.5012 10.3211 14.2116 9.80526 13.6959C9.28944 13.1803 8.99958 12.4808 8.99945 11.7515C8.99937 11.2775 9.12166 10.8161 9.34884 10.4095L6.9775 8.03816ZM10.5122 11.5729C10.5037 11.6316 10.4994 11.6912 10.4994 11.7512C10.4995 12.0828 10.6313 12.4007 10.8657 12.6351C11.1002 12.8695 11.4182 13.0011 11.7497 13.0011C11.8096 13.001 11.8691 12.9967 11.9276 12.9883L10.5122 11.5729ZM11.7481 6.5C11.1875 6.49855 10.6282 6.55386 10.0788 6.66509C9.67283 6.74727 9.2771 6.48479 9.19491 6.07881C9.11273 5.67283 9.37521 5.2771 9.78119 5.19491C10.4295 5.06366 11.0895 4.99836 11.751 5C11.7513 5 11.7516 5 11.7519 5L11.75 5.75V5C11.7503 5 11.7507 5 11.751 5C15.6922 5.00038 18.9036 7.21488 21.3931 11.3641C21.5356 11.6016 21.5356 11.8984 21.3931 12.1359C20.7038 13.2847 19.959 14.2867 19.1571 15.1352C18.8725 15.4362 18.3978 15.4496 18.0968 15.1651C17.7958 14.8805 17.7824 14.4058 18.0669 14.1048C18.6954 13.4399 19.2971 12.656 19.8694 11.75C19.9491 11.8762 20.0283 12.0048 20.1069 12.1359L20.75 11.75L20.1069 11.3641C20.0283 11.4951 19.9491 11.6237 19.8694 11.75C17.6063 8.16603 14.8975 6.5 11.75 6.5L11.7481 6.5Z" fill="#2F2C2C"/>
          </svg>
        </span>
      </button>
    </div>
  [#else]
    <input
      id="${id}"
      type="${type}"
      name="${name}"
      placeholder="${placeholder?has_content?then(placeholder, label)}"
      [#if type != "password"]value="${value}"[/#if]
      class="input input-bordered w-full h-12
        [#if leftAddon?has_content && leftAddon != "none"] rounded-l-none [/#if]
        [#if (fieldMessages[name]![])?size > 0] input-error [/#if]
        focus:outline-none focus:ring-0
        ${class}
      "
      autocapitalize="${autocapitalize}"
      autocomplete="${autocomplete}"
      autocorrect="${autocorrect}"
      spellcheck="${spellcheck}"
      [#if autofocus]autofocus="autofocus"[/#if]
      [#if disabled]disabled="disabled"[/#if]
    />
  [/#if]
  [#if dateTimeFormat != ""]
      <input type="hidden" name="${name}@dateTimeFormat" value="${dateTimeFormat}"/>
  [/#if]
  [#if leftAddon?has_content && leftAddon != "none"]
  </div>
  [/#if]
[/#macro]

[#macro _input_checkbox name value uncheckedValue label tooltip required=false id=""]
<label class="custom-checkbox-label font-suisseintl-regular text-base text-[#2f2c2c] flex items-start gap-3 cursor-pointer my-2 min-w-0" style="user-select: none;">
  [#local actualValue = ("((" + name + ")!'')")?eval/]
  [#local checked = actualValue?is_boolean?then(actualValue == value?boolean, actualValue == value)/]
  [#if uncheckedValue?has_content]
    <input type="hidden" name="__cb_${name}" value="${uncheckedValue}"/>
  [/#if]
  <input type="checkbox"
         class="custom-checkbox-input"
         name=${name}
         value="${value}"
         [#if id?has_content]id="${id}"[/#if]
         [#if checked]checked=checked[/#if]
         style="position: absolute; opacity: 0; width: 0; height: 0; pointer-events: none;"
         [#if required]required[/#if]
  />
  <span class="custom-checkbox-box flex-shrink-0"></span>
  <span class="text-left flex-1 min-w-0">
    ${label!''}
    [#nested/]
  </span>
  [#if tooltip?has_content]
    <i class="fa fa-info-circle flex-shrink-0" data-tooltip="${tooltip}"></i>
  [/#if]
</label>
[/#macro]

[#-- Select --]
[#macro select name id autocapitalize="none" autofocus=false label="" required=false tooltip="" disabled=false class="select" options=[]]
<div class="form-row">
  [#if label?has_content]
  [#compress]
    <label for="${id}"[#if (fieldMessages[name]![])?size > 0] class="error"[/#if]>${label}[#if required] <span class="required">*</span>[/#if]
    [#if tooltip?has_content]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>
    [/#if]
    </label>
  [/#compress]
  [/#if]
  <label class="select">
    [#local value=("((" + name + ")!'')")?eval/]
    [#if name == "user.timezone" || name == "registration.timezone"]
      <select id="${id}" class="${class}" name="${name}">
        [#list timezones as option]
          [#local selected = value == option/]
          <option value="${option}" [#if selected]selected="selected"[/#if] >${option}</option>
        [/#list]]
      </select>
    [#else]
    <select id="${id}" class="${class}" name="${name}">
      [#list options as option]
        [#local selected = value == option/]
        <option value="${option}" [#if selected]selected="selected"[/#if] >${theme.optionalMessage(option)}</option>
      [/#list]
    </select>
    [/#if]
  </label>
  [@errors field=name/]
</div>
[/#macro]

[#-- Text Area --]
[#macro textarea name id autocapitalize="none" autofocus=false label="" required=false tooltip="" disabled=false class="textarea" placeholder=""]
<div class="form-row">
  <textarea id="${id}" name="${name}" class="${class}">${(name?eval!'')}</textarea>
  [@errors field=name/]
</div>
[/#macro]

[#-- Begin : Used for Advanced Registration.
     The following form controls require a 'field' argument which is only available during registration. --]

[#-- Radio List --]
[#macro radio_list field name id autocapitalize="none" autofocus=false label="" required=false tooltip="" disabled=false class="radio-list" options=[]]
<div class="form-row">
  [#if label?has_content]
  [#compress]
  <label for="${id}"[#if (fieldMessages[name]![])?size > 0] class="error"[/#if]>${label}[#if required] <span class="required">*</span>[/#if]
    [#if tooltip?has_content]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>
    [/#if]
  </label>
  [/#compress]
  [/#if]
  [#local value=("((" + name + ")!'')")?eval/]
  <div id="${id}" class="${class}">
    [#list options as option]
      [#local checked = value == option/]
      [#if field.type == "consent"]
        [#local checked = consents(field.consentId)?? && consents(field.consentId)?contains(option)]
      [/#if]
      <label class="radio"><input type="radio" name="${name}" value="${option}" [#if checked]checked="checked"[/#if]><span class="box"></span><span class="label">${theme.optionalMessage(option)}</span></label>
    [/#list]
  </div>
  [@errors field=name/]
</div>
[/#macro]

[#macro checkbox field name id autocapitalize="none" autofocus=false label="" required=false tooltip="" disabled=false class="checkbox"]
<div class="form-row">
   <label class="${class}">
     [#local value=("((" + name + ")!'')")?eval/]
     [#local checked = value?has_content]
     [#if field.type == "consent"]
       [#local checked = consents(field.consentId)??]
     [/#if]
     <input id="${id}" type="checkbox" name="${name}" value="${value}" [#if checked]checked="checked"[/#if]>
       <span class="box"></span>
       <span class="label">${theme.optionalMessage(name)}</span>
   </label>
  [@errors field=name/]
</div>
[/#macro]

[#macro checkbox_list field name id autocapitalize="none" autofocus=false label="" required=false tooltip="" disabled=false class="checkbox-list" options=[]]
<div class="form-row">
  [#if label?has_content][#t/]
  <label for="${id}"[#if (fieldMessages[name]![])?size > 0] class="error"[/#if]>${label}[#if required] <span class="required">*</span>[/#if][#t/]
    [#if tooltip?has_content][#t/]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
    [/#if][#t/]
  </label>[#t/]
  [/#if]
  <div id="${id}" class="${class}">
    [#list options as option]
      [#local value=("((" + name + ")!'')")?eval/]
      [#local checked = value?is_sequence && value?seq_contains(option)/]
      [#if field.type == "consent"]
        [#local checked = consents(field.consentId)?? && consents(field.consentId)?contains(option)]
      [/#if]
      <label class="custom-checkbox-label font-suisseintl-regular text-base text-[#2f2c2c] flex items-start gap-3 cursor-pointer my-2 min-w-0" style="user-select: none;">
        <input type="checkbox" class="custom-checkbox-input" name="${name}" value="${option}" [#if checked]checked="checked"[/#if] style="display: none;"/>
        <span class="custom-checkbox-box flex-shrink-0"></span>
        <span class="text-left flex-1 min-w-0">${theme.optionalMessage(option)}</span>
      </label>
    [/#list]
  </div>
  [@errors field=name/]
</div>
[/#macro]

[#macro locale_select field name id autofocus=false label="" required=false tooltip="" class="select"]
  [#-- Note: This is a simple imlementation that does not support selecting more than one locale.
             You may wish to use a multi-select or some other JavaScript widget to allow for more than one selection and to improve UX --]
  [#local value=("((" + name + ")!'')")?eval/]
  <div class="form-row">
    [#if label?has_content][#t/]
    <label for="${id}"[#if (fieldMessages[name]![])?size > 0] class="error"[/#if]>${label}[#if required] <span class="required">*</span>[/#if][#t/]
      [#if tooltip?has_content][#t/]
        <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
      [/#if][#t/]
    </label>[#t/]
    [/#if]
    <label class="select">
      <select name="${name}" id="${id}" class="${class}" [#if autofocus]autofocus="autofocus"[/#if]>
        <option value="">${theme.optionalMessage("none-selected")}</option>
      [#list fusionAuth.locales() as l, n]
        [#local checked = value?is_sequence && value?seq_contains(l)/]
        <option  value="${l}" [#if checked]selected[/#if]>${l.getDisplayName()}</option>
      [/#list]
     </select>
   </label>
   [@errors field=name/]
  </div>
[/#macro]

[#-- End : Used for Advanced Registration. --]

[#macro oauthHiddenFields]
  [@hidden name="captcha_token"/]
  [@hidden name="client_id"/]
  [@hidden name="code_challenge"/]
  [@hidden name="code_challenge_method"/]
  [@hidden name="metaData.device.name"/]
  [@hidden name="metaData.device.type"/]
  [@hidden name="nonce"/]
  [@hidden name="oauth_context"/]
  [@hidden name="pendingIdPLinkId"/]
  [@hidden name="redirect_uri"/]
  [@hidden name="response_mode"/]
  [@hidden name="response_type"/]
  [@hidden name="scope"/]
  [@hidden name="state"/]
  [@hidden name="tenantId"/]
  [@hidden name="timezone"/]
  [@hidden name="user_code"/]
[/#macro]

[#macro errors field]
[#if fieldMessages[field]?has_content]
<span class="text-error mt-1 block" style="font-size: 12px;">[#list fieldMessages[field] as message]${message?no_esc}[#if message_has_next], [/#if][/#list]</span>
[/#if]
[/#macro]

[#macro button text icon="" color="btn-primary" size="lg" disabled=false name="" value="" id=""]
<button
  class="btn ${color} btn-${size} w-full flex items-center justify-center gap-2 uppercase font-bold tracking-wide btn-border-custom${disabled?then(' btn-disabled', '')}"
  [#if id?has_content]id="${id}"[/#if]
  [#if disabled]disabled="disabled"[/#if]
  [#if name?has_content]name="${name}"[/#if]
  [#if value?has_content]value="${value}"[/#if]
>
  <span class="btn-text text-sm">${text}</span>

  [#if icon?has_content]
    <i class="fa fa-light fa-${icon} text-lg btn-icon"></i>
  [/#if]

  <span class="btn-spinner">
    <svg class="animate-spin" width="20" height="20" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle style="opacity: 0.25" cx="12" cy="12" r="10" stroke="#2f2c2c" stroke-width="4"></circle>
      <path style="opacity: 0.75" fill="#2f2c2c" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
  </span>
</button>
[/#macro]

[#macro link url extraParameters="" class=""]
<a 
  href="${url}?tenantId=${(tenantId)!''}&client_id=${(client_id)!''}&nonce=${(nonce?url)!''}&pendingIdPLinkId=${(pendingIdPLinkId)!''}&redirect_uri=${(redirect_uri?url)!''}&response_mode=${(response_mode?url)!''}&response_type=${(response_type?url)!''}&scope=${(scope?url)!''}&state=${(state?url)!''}&timezone=${(timezone?url)!''}&metaData.device.name=${(metaData.device.name?url)!''}&metaData.device.type=${(metaData.device.type?url)!''}${(extraParameters!'')?no_esc}&code_challenge=${(code_challenge?url)!''}&code_challenge_method=${(code_challenge_method?url)!''}&user_code=${(user_code?url)!''}"
  class="font-suisseintl-regular text-base ${class}">
[#nested/]
</a>
[/#macro]

[#macro logoutLink redirectURI extraParameters=""]
[#-- Note that in order for the post_logout_redirect_uri to be correctly URL escaped, you must use this syntax for assignment --]
[#local post_logout_redirect_uri]${redirectURI}?tenantId=${(tenantId)!''}&client_id=${(client_id)!''}&nonce=${(nonce?url)!''}&pendingIdPLinkId=${(pendingIdPLinkId)!''}&redirect_uri=${(redirect_uri?url)!''}&response_mode=${(response_mode?url)!''}&response_type=${(response_type?url)!''}&scope=${(scope?url)!''}&state=${(state?url)!''}&timezone=${(timezone?url)!''}&metaData.device.name=${(metaData.device.name?url)!''}&metaData.device.type=${(metaData.device.type?url)!''}${(extraParameters?no_esc)!''}&code_challenge=${(code_challenge?url)!''}&code_challenge_method=${(code_challenge_method?url)!''}&user_code=${(user_code?url)!''}[/#local]
<a href="/oauth2/logout?tenantId=${(tenantId)!''}&client_id=${(client_id)!''}&post_logout_redirect_uri=${post_logout_redirect_uri?markup_string?url}">[#t]
  [#nested/][#t]
</a>[#t]
[/#macro]

[#macro defaultIfNull text default]
  ${text!default}
[/#macro]

[#macro passwordRules passwordValidationRules]
<div class="text-error" style="font-size: 12px;">
  <span>
    ${theme.message('password-constraints-intro')}
  </span>
  <ul>
    <li>${theme.message('password-length-constraint', passwordValidationRules.minLength, passwordValidationRules.maxLength)}</li>
    [#if passwordValidationRules.requireMixedCase]
      <li>${theme.message('password-case-constraint')}</li>
    [/#if]
    [#if passwordValidationRules.requireNonAlpha]
      <li>${theme.message('password-alpha-constraint')}</li>
    [/#if]
    [#if passwordValidationRules.requireNumber]
      <li>${theme.message('password-number-constraint')}</li>
    [/#if]
    [#if passwordValidationRules.rememberPreviousPasswords.enabled]
      <li>${theme.message('password-previous-constraint', passwordValidationRules.rememberPreviousPasswords.count)}</li>
    [/#if]
  </ul>
</div>
[/#macro]

[#macro customField field key autofocus=false placeholder="" label="" leftAddon="true"]
  [#assign fieldId = field.key?replace(".", "_") /]
  [#local leftAddon = (leftAddon == "true")?then(field.data.leftAddon!'info', "") /]

  [#if field.key == "user.preferredLanguages" || field.key == "registration.preferredLanguages"]
    [@locale_select field=field id="${fieldId}" name="${field.key}" required=field.required autofocus=autofocus label=label /]
  [#elseif field.control == "checkbox"]
    [#if field.options?has_content]
      [@checkbox_list field=field id="${fieldId}" name="${key}" required=field.required autofocus=autofocus label=label options=field.options /]
    [#else]
      [@checkbox field=field id="${fieldId}" name="${key}" required=field.required autofocus=autofocus label=label /]
    [/#if]
  [#elseif field.control == "number"]
    [@input id="${fieldId}" type="number" name="${key}" leftAddon="${leftAddon}" required=field.required autofocus=autofocus label=label placeholder=theme.optionalMessage(placeholder) /]
  [#elseif field.control == "password"]
    [@input id="${fieldId}" type="password" name="${key}" leftAddon="lock" autocomplete="new-password" autofocus=autofocus label=label placeholder=theme.optionalMessage(placeholder)/]
  [#elseif field.control == "radio"]
    [@radio_list field=field id="${fieldId}" name="${key}" required=field.required autofocus=autofocus label=label options=field.options /]
  [#elseif field.control == "select"]
    [@select id="${fieldId}" name="${key}" required=field.required autofocus=autofocus label=label options=field.options /]
  [#elseif field.control == "textarea"]
    [@textarea id="${fieldId}" name="${key}" required=field.required autofocus=autofocus label=label placeholder=theme.optionalMessage(placeholder) /]
  [#elseif field.control == "text"]
    [#if field.type == "date"]
      [@input id="${fieldId}" type="text" name="${key}" leftAddon="${leftAddon}" required=field.required autofocus=autofocus label=label placeholder=theme.optionalMessage(placeholder) class="date-picker" dateTimeFormat="yyyy-MM-dd" /]
    [#else]
      [@input id="${fieldId}" type="text" name="${key}" leftAddon="${leftAddon}" required=field.required autofocus=autofocus label=label placeholder=theme.optionalMessage(placeholder)/]
    [/#if]
  [/#if]
[/#macro]

[#function display object propertyName default="\x2013" ]
  [#assign value=("((object." + propertyName + ")!'')")?eval/]
  [#-- ?has_content is false for boolean types, check it first --]
  [#if value?has_content]
    [#if value?is_number]
      [#return value?string('#,###')]
    [#else]
      [#return (value == default?is_markup_output?then(default?markup_string, default))?then(value, value?string)]
    [/#if]
  [#else]
    [#return default]
  [/#if]
[/#function]

[#macro passwordField field showCurrentPasswordField=false]
  [#-- Render checkbox used to determine whether the form submit should update password--]
  <div class="form-row">
    <label for="editPasswordOption"> ${theme.optionalMessage("change-password")} </label>
    <input type="hidden" name="__cb_editPasswordOption" value="useExisting">
    <label class="toggle">
      <input id="editPasswordOption" type="checkbox" name="editPasswordOption" value="update" data-slide-open="password-fields" [#if editPasswordOption == "update"]checked[/#if]>
      <span class="rail"></span>
      <span class="pin"></span>
    </label>
  </div>
  <div id="password-fields" class="slide-open ${(editPasswordOption == "update")?then('open', '')}">
    [#-- See if the application requires the current password --]
    [#if showCurrentPasswordField]
      [@customField field=field key="currentPassword" autofocus=false label=theme.optionalMessage("current-password")/]
    [/#if]

    [#-- Show the Password Validation Rules if there is a field error for 'user.password' --]
    [#if (fieldMessages?keys?seq_contains("user.password")!false) && passwordValidationRules??]
      [@passwordRules passwordValidationRules/]
    [/#if]

    [#-- Render password field--]
    [@customField field=field key=field.key autofocus=false placeholder=field.key label=theme.optionalMessage(field.key) leftAddon="false"/]

    [#-- Render confirm if set to true on the field     --]
    [#if field.confirm]
      [@customField field "confirm.${field.key}" false "[confirm]${field.key}" /]
    [/#if]
  </div>
[/#macro]

[#macro captchaScripts showCaptcha captchaMethod siteKey=""]
  [#if showCaptcha]
    [#if captchaMethod == "GoogleRecaptchaV2"]
      <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    [/#if]
    [#if captchaMethod == "GoogleRecaptchaV3"]
      <script src="https://www.google.com/recaptcha/api.js?render=${siteKey}"></script>
    [/#if]
    [#if captchaMethod == "HCaptcha" || captchaMethod == "HCaptchaEnterprise"]
      <script src="https://hcaptcha.com/1/api.js" async defer></script>
    [/#if]
    <script src="${request.contextPath}/js/oauth2/Captcha.js?version=${version}"></script>
    <script data-captcha-method="${captchaMethod!''}" data-site-key="${siteKey!''}">
      Prime.Document.onReady(function() {
        new FusionAuth.OAuth2.Captcha();
      });
    </script>
  [/#if]
[/#macro]

[#macro captchaBadge showCaptcha captchaMethod siteKey=""]
  [#-- If you want to remove captcha from the page, also ensure you disable it in the tenant configruation. --]
  [#if showCaptcha]
    [#if captchaMethod == "GoogleRecaptchaV2"]
      <div class="g-recaptcha" data-sitekey="${siteKey!''}"
        [#-- To use the invisible mode, un-comment the following two data- attributes. For more information see: https://developers.google.com/recaptcha/docs/invisible --]
        [#--
        data-size="invisible"
        data-callback="reCaptchaV2InvisibleCallback"
        --]
      ></div>
    [#elseif captchaMethod == "GoogleRecaptchaV3"]
      [#-- This is the replacement Terms and Conditions messaging that is required by Google when hiding the
           standard badge. If you want to remove this you will also need to remove or edit the CSS above. --]
      <div class="grecaptcha-msg text-center !text-xs !font-suisseintl-regular my-1">
        ${theme.message('captcha-google-branding')?no_esc}
      </div>
    [#elseif captchaMethod == "HCaptcha" || captchaMethod == "HCaptchaEnterprise"]
      <div class="h-captcha" data-sitekey="${siteKey!''}"></div>
    [/#if]
    [@errors field="captcha_token"/]
  [/#if]
[/#macro]

[#macro scopeConsentField application scope type]
  [#-- Resolve the consent message and detail for the provided scope --]
  [#if type != "unknown"]
    [#local scopeMessage = resolveScopeMessaging('message', application, scope.name, scope.defaultConsentMessage!scope.name) /]
    [#local scopeDetail = resolveScopeMessaging('detail', application, scope.name, scope.defaultConsentDetail!'') /]
  [/#if]

  [#if type == "required"]
    [#-- Required scopes should use a hidden form field with a value of "true". The user cannot change this selection, --]
    [#-- but there should be a display element to inform the user that they must consent to the scopes to continue. --]
    <div class="form-row consent-item col-lg-offset-0">
      [@hidden name="scopeConsents['${scope.name}']" value="true" /]
      <i class="fa fa-check"></i>
      <span>
        ${scopeMessage}
        [#if scopeDetail?has_content]
          <i class="fa fa-info-circle" data-tooltip="${scopeDetail}"></i>
        [/#if]
      </span>
    </div>
  [#elseif type == "optional"]
    [#-- Optional scopes should render a checkbox to allow a user to change their selection. The available values should be "true" and "false" --]
    <div class="consent-item col-lg-offset-0">
      [@input type="checkbox" name="scopeConsents['${scope.name}']" id="${scope.name}" label=scopeMessage value="true" uncheckedValue="false" tooltip=scopeDetail /]
    </div>
  [#elseif type == "unknown"]
    [#-- Unknown scopes and the reserved "openid" and "offline_access" scopes are considered required and do not have an associated display element. --]
    [@hidden name="scopeConsents['${scope}']" value="true" /]
  [/#if]
[/#macro]

[#function resolveScopeMessaging messageType application scopeName default]
  [#-- Application specific, tenant specific, not application/tenant specific, then default --]
  [#local message = theme.optionalMessage("[{application}${application.id}]{scope-${messageType}}${scopeName}") /]
  [#local resolvedMessage = message != "[{application}${application.id}]{scope-${messageType}}${scopeName}" /]
  [#if !resolvedMessage]
     [#local message = theme.optionalMessage("[{tenant}${application.tenantId}]{scope-${messageType}}${scopeName}") /]
     [#local resolvedMessage = message != "[{tenant}${application.tenantId}]{scope-${messageType}}${scopeName}" /]
  [/#if]
  [#if !resolvedMessage]
    [#local message = theme.optionalMessage("{scope-${messageType}}${scopeName}") /]
    [#local resolvedMessage = message != "{scope-${messageType}}${scopeName}" /]
  [/#if]
  [#if !resolvedMessage]
    [#return default /]
  [#else]
    [#return message /]
  [/#if]
[/#function]

[#macro dividerOr]
  <div class="divider-or">
    <span class="divider-line"></span>
    <span class="divider-text">or</span>
    <span class="divider-line"></span>
  </div>
[/#macro]

[#assign baseFrontendUrl = "https://staging.centr.com" /]
[#function frontendUrl path=""]
  [#return baseFrontendUrl + path]
[/#function]

[#-- Helper function to URL encode the frontend URL for redirect URIs --]
[#function frontendUrlEncoded path=""]
  [#return (baseFrontendUrl + path)?url]
[/#function]
[#-- Phone verification macros (required by FusionAuth) --]
[#function addDataAttributes dataMap]
  [#-- Converts a map to data attributes --]
  [#local attr = "" /]
  [#list dataMap as key, value]
    [#if attr?has_content]
      [#local attr = attr + " " /]
    [/#if]
    [#if value?? && value?has_content]
      [#local attr = attr + "data-" + key + "=\""?no_esc + value + "\""?no_esc/]
    [#else]
      [#local attr = attr + "data-" + key + ' ' /]
    [/#if]
  [/#list]
  [#return attr /]
[/#function]

[#macro orSeparator]
  <div class="relative flex items-center my-8">
    <div class="flex-grow border-t border-slate-300"></div>
    <span class="flex-shrink mx-4 text-sm text-slate-600">${theme.message("or")}</span>
    <div class="flex-grow border-t border-slate-300"></div>
  </div>
[/#macro]

[#macro structuredForm action method id="" dataAttributes={}]
  <form [#if id?has_content]id="${id}"[/#if] action="${action}" method="${method}" class="flex flex-col" ${addDataAttributes(dataAttributes)}>
    <fieldset class="space-y-4">
        [#nested "formFields" /]
    </fieldset>
    <fieldset class="mt-6 space-y-6">
        [#nested "buttons" /]
    </fieldset>
  </form>
[/#macro]

[#macro linkButton text color="blue" disabled=false name="" value="" formaction="" id=""]
  [#-- Buttons that look like links --]
  <button class="cursor-pointer" [#if formaction?has_content]formaction="${formaction}"[/#if] [#if id?has_content]id="${id}"[/#if]><i class="fa fa-arrow-right"></i>&nbsp;<span class="link text-link hover:text-link-hover hover:underline">${text}</span></button>
[/#macro]