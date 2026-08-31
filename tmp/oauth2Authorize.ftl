[#ftl/]
[#setting url_escaping_charset="UTF-8"]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="bootstrapWebauthnEnabled" type="boolean" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="code_challenge" type="java.lang.String" --]
[#-- @ftlvariable name="code_challenge_method" type="java.lang.String" --]
[#-- @ftlvariable name="devicePendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="federatedCSRFToken" type="java.lang.String" --]
[#-- @ftlvariable name="hasDomainBasedIdentityProviders" type="boolean" --]
[#-- @ftlvariable name="identityProviders" type="java.util.Map<java.lang.String, java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider<?>>>" --]
[#-- @ftlvariable name="idpRedirectState" type="java.lang.String" --]
[#-- @ftlvariable name="loginId" type="java.lang.String" --]
[#-- @ftlvariable name="metaData" type="io.fusionauth.domain.jwt.RefreshToken.MetaData" --]
[#-- @ftlvariable name="nonce" type="java.lang.String" --]
[#-- @ftlvariable name="passwordlessEnabled" type="boolean" --]
[#-- @ftlvariable name="pendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="redirect_uri" type="java.lang.String" --]
[#-- @ftlvariable name="rememberDevice" type="boolean" --]
[#-- @ftlvariable name="response_type" type="java.lang.String" --]
[#-- @ftlvariable name="scope" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="showPasswordField" type="boolean" --]
[#-- @ftlvariable name="showWebAuthnReauthLink" type="boolean" --]
[#-- @ftlvariable name="state" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="timezone" type="java.lang.String" --]
[#-- @ftlvariable name="user_code" type="java.lang.String" --]
[#-- @ftlvariable name="version" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Login | Centr"]
    <script src="${request.contextPath}/js/jstz-min-1.0.6.js"></script>
    [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
    <script src="${request.contextPath}/js/oauth2/Authorize.js?version=${version}"></script>
    <script src="${request.contextPath}/js/identityProvider/InProgress.js?version=${version}"></script>
    [@helpers.alternativeLoginsScript clientId=client_id identityProviders=identityProviders/]
    <script>
      Prime.Document.onReady(function() {
        [#-- This object handles guessing the timezone, filling in the device id of the user, and check for WebAuthn re-authentication support --]
        new FusionAuth.OAuth2.Authorize();
      });
    </script>
    <script type="text/javascript">
    /*
     * Redirect mobile app users to registration page when redirectFusionAuthTo=register flag is present.
     *
     * Mobile apps use this flag in redirect_uri to direct users to registration instead of login.
     * We use sessionStorage to track the redirect and avoid modifying the redirect_uri parameter
     * to prevent PKCE validation failures in FusionAuth.
     */
    (function() {
        try {
            var redirectUri = "${redirect_uri!''}";
            if (redirectUri && redirectUri.includes('redirectFusionAuthTo=register')) {
                // Check if we've already redirected to prevent loops
                var hasRedirected = false;
                try {
                    hasRedirected = sessionStorage.getItem('redirectFusionAuthToRegister') === 'true';
                } catch (e) {
                    // sessionStorage not available, continue with redirect
                }

                if (!hasRedirected) {
                    try {
                        sessionStorage.setItem('redirectFusionAuthToRegister', 'true');
                    } catch (e) {
                        // sessionStorage failed, continue with redirect anyway
                    }

                    var url = new URL(window.location.href);
                    var newPath = url.pathname.replace('/oauth2/authorize', '/oauth2/register');
                    url.pathname = newPath;
                    window.location.replace(url.toString());
                }
            }
        } catch (e) {
            // Silently fail - don't break the auth flow
            console.warn('Registration redirect failed:', e);
        }
    })();

    /*
     * Shopify's external identity provider flow does not forward any parameter
     * (e.g. prompt=create) that distinguishes a "create account" entry point from
     * a plain sign-in, so we can't detect intent directly. As a proxy, when
     * FusionAuth is reached via the Shopify redirect_uri with a login_hint already
     * populated (Shopify already knows the customer's email, e.g. from the
     * warranty registration flow), default to the register tab instead of login.
     */
    (function() {
        try {
            var redirectUri = "${redirect_uri!''}";
            var loginHint = "${login_hint!''}";
            if (redirectUri && redirectUri.includes('https://shopify.com/authentication') && loginHint) {
                var hasRedirected = false;
                try {
                    hasRedirected = sessionStorage.getItem('shopifyLoginHintRegisterRedirect') === 'true';
                } catch (e) {
                    // sessionStorage not available, continue with redirect
                }

                if (!hasRedirected) {
                    try {
                        sessionStorage.setItem('shopifyLoginHintRegisterRedirect', 'true');
                    } catch (e) {
                        // sessionStorage failed, continue with redirect anyway
                    }

                    var url = new URL(window.location.href);
                    var newPath = url.pathname.replace('/oauth2/authorize', '/oauth2/register');
                    url.pathname = newPath;
                    window.location.replace(url.toString());
                }
            }
        } catch (e) {
            // Silently fail - don't break the auth flow
            console.warn('Shopify login_hint register redirect failed:', e);
        }
    })();

    /*
     * Detect Amplitude experiment parameter from redirect_uri and store in sessionStorage for signup page title variation.
     */
    (function() {
        try {
            var redirectUri = "${redirect_uri!''}";
            if (redirectUri && redirectUri.includes('experimentAmplitudeVariant=')) {
                var match = redirectUri.match(/experimentAmplitudeVariant=([^&]+)/);
                if (match && match[1]) {
                    sessionStorage.setItem('experimentAmplitudeVariant', decodeURIComponent(match[1]));
                }
            }
        } catch (e) {
            // Silently fail
        }
    })();
    </script>
    <script>
      Prime.Document.onReady(function() {
        const redirectURI = "${redirect_uri!''}";
        const loginHint = "${login_hint!''}";
        if (!redirectURI.includes('https://shopify.com/authentication') || !loginHint) return;

        const warrantyMessages = { 
          eyebrow: "${theme.message('warranty-eyebrow')}",
          headingLine1: "${theme.message('warranty-heading-line1')}",
          headingLine2: "${theme.message('warranty-heading-line2')}",
          description: "${theme.message('warranty-description')}",
        }

        const warrantyElements = {
          eyebrow: document.querySelector('.authcard-eyebrow'),
          headingLine1: document.querySelector('.heading-line-1'),
          headingLine2: document.querySelector('.heading-line-2'),
          description: document.querySelector('.authcard-description'),
        }

        Object.keys(warrantyElements).forEach(key => {
          if (warrantyElements[key]){
            warrantyElements[key].innerText = warrantyMessages[key]
          }
        })

        if (document.querySelector('.authcard-heading')){
          document.querySelector('.authcard-heading').classList.add('authcard-warranty')
        }
      });
    </script>
  [/@helpers.head]
  [@helpers.body]
    [#-- Rebranded auth card: two-column layout with marketing copy + Sign In / Create Account tabs --]
    [@helpers.authCard
      mode="split"
      activeTab="signin"
      eyebrow=theme.message('account-sign-in-eyebrow')
      headingLine1=theme.message('account-sign-in-heading-line1')
      headingLine2=theme.message('account-sign-in-heading-line2')
      description=theme.message('account-sign-in-description')]
      [#-- During a linking work flow, optionally indicate to the user which IdP is being linked. --]
      [#if devicePendingIdPLink?? || pendingIdPLink??]
        <p class="mt-0">
        [#if devicePendingIdPLink?? && pendingIdPLink??]
          ${theme.message('pending-links-login-to-complete', devicePendingIdPLink.identityProviderName, pendingIdPLink.identityProviderName)}
        [#elseif devicePendingIdPLink??]
          ${theme.message('pending-link-login-to-complete', devicePendingIdPLink.identityProviderName)}
        [#else]
          ${theme.message('pending-link-login-to-complete', pendingIdPLink.identityProviderName)}
        [/#if]
        [#-- A pending link can be cancled. If we also have a device link in progress, this cannot be canceled. --]
        [#if pendingIdPLink??]
          [@helpers.link url="" extraParameters="&cancelPendingIdpLink=true"]${theme.message("login-cancel-link")}[/@helpers.link]
        [/#if]
        </p>
      [/#if]
      <form action="${request.contextPath}/oauth2/authorize" method="POST" class="flex flex-col gap-3 w-full mt-3">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="showPasswordField"/]
        [@helpers.hidden name="userVerifyingPlatformAuthenticatorAvailable"/]
        [#if showPasswordField && hasDomainBasedIdentityProviders]
          [@helpers.hidden name="loginId"/]
        [/#if]

        <fieldset class="grid lg:grid-cols-2 gap-4">
          [@helpers.input type="text" name="loginId" id="loginId" label=theme.message("loginId") autocomplete="username" autocapitalize="none" autocorrect="off" spellcheck="false" autofocus=false required=true/]
          [#if showPasswordField]
            [@helpers.input type="password" name="password" id="password" label=theme.message("password") autocomplete="current-password" autofocus=false required=true/]
            [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
            <div class="w-full text-center -mt-2.5 lg:col-span-1 lg:col-start-2">
              [@helpers.link url="${request.contextPath}/password/forgot" extraParameters="" class="!text-[#E5DDCFBF] uppercase !text-xs"]<span>${theme.message("forgot-your-password")}</span>[/@helpers.link]
            </div>
          [/#if]

          [@helpers.hidden name="rememberDevice" value="false"/]
        </fieldset>

        [#if showPasswordField]
          [@helpers.button icon="arrow-right" text=theme.message("login")/]
        [#else]
          [@helpers.button icon="arrow-right" text=theme.message("next")/]
        [/#if]
      </form>

      [@helpers.dividerOr/]

      [@helpers.alternativeLogins
        clientId=client_id
        identityProviders=identityProviders![]
        passwordlessEnabled=passwordlessEnabled
        bootstrapWebauthnEnabled=bootstrapWebauthnEnabled
        idpRedirectState=idpRedirectState
        federatedCSRFToken=federatedCSRFToken
        showOrDivider=false
      /]

      <div>
        [#if showPasswordField && hasDomainBasedIdentityProviders]
          [@helpers.link url="" extraParameters="&showPasswordField=false"]${theme.message("sign-in-as-different-user")}[/@helpers.link]
        [/#if]
      </div>

     [#if showWebAuthnReauthLink]
       [@helpers.link url="${request.contextPath}/oauth2/webauthn-reauth"] ${theme.message("return-to-webauthn-reauth")} [/@helpers.link]
     [/#if]
    [/@helpers.authCard]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]

  [/@helpers.body]
[/@helpers.html]