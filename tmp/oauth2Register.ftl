[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="collectBirthDate" type="boolean" --]
[#-- @ftlvariable name="devicePendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="federatedCSRFToken" type="java.lang.String" --]
[#-- @ftlvariable name="fields" type="java.util.List<io.fusionauth.domain.form.FormField>" --]
[#-- @ftlvariable name="hideBirthDate" type="boolean" --]
[#-- @ftlvariable name="identityProviders" type="java.util.Map<java.lang.String, java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider<?>>>" --]
[#-- @ftlvariable name="idpRedirectState" type="java.lang.String" --]
[#-- @ftlvariable name="passwordValidationRules" type="io.fusionauth.domain.PasswordValidationRules" --]
[#-- @ftlvariable name="parentEmailRequired" type="boolean" --]
[#-- @ftlvariable name="pendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="step" type="int" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="totalSteps" type="int" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Sign-up | Centr"]
    <script src="${request.contextPath}/js/identityProvider/InProgress.js?version=${version}"></script>
    [@helpers.alternativeLoginsScript clientId=client_id identityProviders=identityProviders/]
    [#if step == totalSteps]
      [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
    [/#if]
    <script type="text/javascript">
      /**
       * WebAuthn Platform Authenticator Detection
       * 
       * This script detects if the user's device supports WebAuthn platform authenticators
       * and sets the appropriate field value for the registration form.
       */
      document.addEventListener('DOMContentLoaded', () => {
        const uvpaAvailableField = document.querySelector('input[name="userVerifyingPlatformAuthenticatorAvailable"]');
        if (uvpaAvailableField !== null && typeof(PublicKeyCredential) !== 'undefined' && PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable) {
          PublicKeyCredential
            .isUserVerifyingPlatformAuthenticatorAvailable()
            .then(result => uvpaAvailableField.value = result);
        }
      });
    </script>
  [/@helpers.head]
  [@helpers.body]
    [#-- Extract pid and linkRef from state parameter to customize title --]
    [#assign state = request.getParameter("state")!"" /]
    [#assign hasPid = state?contains("pid=") /]
    [#assign hasLinkRef = state?contains("linkRef=") /]
    [#-- VDB: Two-line title - first line white, second line yellow (brand color) --]
    [#assign isFreeTrial = hasPid && hasLinkRef /]

    [#-- Rebranded auth card: two-column layout with marketing copy + Sign In / Create Account tabs --]
    [@helpers.authCard
      mode="split"
      activeTab="register"
      eyebrow=theme.message('account-sign-in-eyebrow')
      headingLine1=theme.message('account-sign-in-heading-line1')
      headingLine2=theme.message('account-sign-in-heading-line2')
      description=theme.message('account-sign-in-description')]
      [#-- VDB: Custom two-line title --]
      <div id="signup-title-container" class="hidden w-full text-left mb-2">
        [#if isFreeTrial]
          <h2 class="font-degular-black text-yellow">${theme.message("register-free-trial")}</h2>
        [#else]
          <h2 id="signup-title-line1" class="font-degular-black">${theme.message("register-progress-line1")!"KEEP YOUR PROGRESS GOING."}</h2>
          <h2 id="signup-title-line2" class="font-degular-black text-yellow">${theme.message("register-progress-line2")!"CREATE YOUR ACCOUNT."}</h2>
        [/#if]
      </div>
      <script type="text/javascript">
      (function() {
        try {
          var experimentVariant = sessionStorage.getItem('experimentAmplitudeVariant');
          if (experimentVariant === 'treatment') {
            var titleLine1 = document.getElementById('signup-title-line1');
            var titleLine2 = document.getElementById('signup-title-line2');
            if (titleLine1) {
              titleLine1.textContent = 'START STRONG.';
            }
            if (titleLine2) {
              titleLine2.textContent = 'CREATE YOUR ACCOUNT.';
            }
          }
        } catch (e) {
          // Silently fail
        }
      })();
      </script>
      [#-- During a linking work flow, optionally indicate to the user which IdP is being linked. --]
      [#if devicePendingIdPLink?? || pendingIdPLink??]
        <p class="mt-0">
        [#if devicePendingIdPLink?? && pendingIdPLink??]
          ${theme.message('pending-links-register-to-complete', devicePendingIdPLink.identityProviderName, pendingIdPLink.identityProviderName)}
        [#elseif devicePendingIdPLink??]
          ${theme.message('pending-link-register-to-complete', devicePendingIdPLink.identityProviderName)}
        [#else]
          ${theme.message('pending-link-register-to-complete', pendingIdPLink.identityProviderName)}
        [/#if]
        [#-- A pending link can be cancled. If we also have a device link in progress, this cannot be canceled. --]
        [#if pendingIdPLink??]
          [@helpers.link url="" extraParameters="&cancelPendingIdpLink=true"]${theme.message("register-cancel-link")}[/@helpers.link]
        [/#if]
        </p>
      [/#if]

        [#-- End Identity Provider Buttons --]
      <form action="${request.contextPath}/oauth2/register" method="POST" class="flex flex-col gap-3 w-full mt-3 ">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="step"/]
        [@helpers.hidden name="registrationState"/]
        [@helpers.hidden name="parentEmailRequired"/]
        [@helpers.hidden name="userVerifyingPlatformAuthenticatorAvailable"/]

        [#-- Show the Password Validation Rules if there is a field error for 'user.password' --]
        [#if (fieldMessages?keys?seq_contains("user.password")!false) && passwordValidationRules??]
          [@helpers.passwordRules passwordValidationRules/]
        [/#if]

        [#-- Begin Self Service Custom Registration Form Steps --]
        [#-- Check if marketing consent field is already in the form fields --]
        [#assign hasMarketingConsentField = false /]
        [#if fields?has_content]
          [#list fields as field]
            [#if (field.key!"")?contains("marketingConsent") || (field.key!"")?contains("marketingOptIn")]
              [#assign hasMarketingConsentField = true /]
              [#break]
            [/#if]
          [/#list]
        [/#if]
        [#if fields?has_content]
          <fieldset class="grid lg:grid-cols-2 gap-3">
            [@helpers.hidden name="collectBirthDate"/]
            [#list fields as field]
              [#--
                This section dynamically renders form fields based on the 'field.type'
                and 'field.control' properties. It ensures that custom fields match
                the theme's styling by using the same helpers as the basic form.
                marketingConsent field uses regional logic (checkbox for UK/EU/CAN/AUS, text for US/others).
              --]
              [#-- Check if this is the marketingConsent field - apply regional logic --]
              [#if (field.key!"")?contains("marketingConsent") || (field.key!"")?contains("marketingOptIn")]
                [#if helpers.requiresOptInCheckbox()]
                  [#-- UK, EU, Canada, Australia: Show checkbox --]
                  [@helpers.input type="checkbox" name=field.key id=field.key class="lg:col-span-2" label=field.name required=false value="true" uncheckedValue="false" /]
                [#else]
                  [#-- US and other countries: Auto opt-in with informational copy --]
                  [@helpers.hidden name=field.key value="true"/]
                  <div class="w-full text-left lg:col-span-2">
                    <span class="font-sans text-sm vdb-info-text text-sand-lightest">We'll send you account updates and occasional product news. Unsubscribe anytime.</span>
                  </div>
                [/#if]
              [#elseif field.control == 'textarea']
                [@helpers.textarea name=field.key id=field.key class="lg:col-span-2"  label=field.name required=field.required/]
              [#elseif field.type == 'bool']
                [@helpers.input type="checkbox" name=field.key id=field.key class="lg:col-span-2" label=field.name required=field.required value="true" uncheckedValue="false" /]
              [#elseif field.type == 'select' || field.control == 'select']
                [@helpers.select name=field.key id=field.key class="lg:col-span-2" label=field.name required=field.required options=field.options![]/]
              [#elseif field.type == 'number']
                [@helpers.input type="number" name=field.key id=field.key class="lg:col-span-2" label=field.name required=field.required/]
              [#elseif field.key?contains('password')]
                [@helpers.input type="password" name=field.key id=field.key class="lg:col-span-2" label=field.name required=field.required placeholder=field.name autofocus=field?is_first autocomplete="new-password"/]
              [#else]
                [#-- Default to text input for string and other types --]
                [#if field.key == 'user.firstName']
                  [@helpers.input type="text" name=field.key id=field.key class="col-span-1" label=field.name required=field.required placeholder=field.name autofocus=field?is_first/]
                [#elseif field.key == 'user.lastName']
                  [@helpers.input type="text" name=field.key id=field.key class="col-span-1" label=field.name required=field.required placeholder=field.name autofocus=field?is_first/]
                [#else]
                  [@helpers.input type="text" name=field.key id=field.key class="lg:col-span-2" label=field.name required=field.required placeholder=field.name autofocus=field?is_first/]
                [/#if]
              [/#if]

              [#if field.confirm]
                [@helpers.input type=(field.key?contains('password'))?then("password", "text") name="confirm.${field.key}" id="confirm.${field.key}" label="Confirm ${field.name}" required=true/]
              [/#if]
            [/#list]
            [#-- If this is the last step of the form, optionally show a captcha. --]
            [#if step == totalSteps]
              [#-- Regional marketing consent: Only render if FusionAuth didn't already render it --]
              [#if !hasMarketingConsentField]
                [#if helpers.requiresOptInCheckbox()]
                  [#-- UK, EU, Canada, Australia: Show checkbox (unchecked by default) --]
                  [@helpers.input type="checkbox" name="user.data.marketingConsent" id="marketingConsent" class="lg:col-span-2" value="true" uncheckedValue="false" label="Get training tips straight to your inbox" /]
                [#else]
                  [#-- US and other countries: Auto opt-in with informational copy --]
                  [@helpers.hidden name="user.data.marketingConsent" value="true"/]
                  <div class="w-full text-left my-4 lg:col-span-2">
                    <span class="font-sans text-sm vdb-info-text text-sand-lightest">We'll send you account updates and occasional product news. Unsubscribe anytime.</span>
                  </div>
                [/#if]
              [/#if]
              [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
              [@helpers.hidden name="rememberDevice" value="false"/]
              [#-- Terms consent checkbox replaced with acceptance statement per CX-7665 --]
              <div class="w-full text-left lg:col-span-2">
                <span class="font-sans text-sm text-sand-lightest">By signing up, you agree to Centr's <a href="${(application.data.privacyPolicyUrl)!'https://centr.com/blog/show/5293/privacy-policy'}" class="underline" target="_blank" rel="noopener noreferrer">Privacy Policy</a> and <a href="${(application.data.termsAndConditionsUrl)!'https://centr.com/blog/show/5294/terms-and-conditions'}" class="underline" target="_blank" rel="noopener noreferrer">Terms & Conditions</a>.</span>
              </div>
            [#else]
              <div class="mt-5 mb-5"></div>
              [@helpers.button icon="arrow-right" text=theme.message('next')/]
            [/#if]
          </fieldset>
        [#-- End Custom Self Service Registration Form Steps --]
        [#else]
        [#-- Begin Basic Self Service Registration Form --]
        <fieldset class="space-y-6" style="min-inline-size: auto;">
          [@helpers.hidden name="collectBirthDate"/]
          [#if !collectBirthDate && (!application.registrationConfiguration.birthDate.enabled || hideBirthDate)]
            [@helpers.hidden name="user.birthDate" dateTimeFormat="yyyy-MM-dd"/]
          [/#if]
          [#if collectBirthDate]
            [@helpers.input type="text" name="user.birthDate" id="birthDate" label=theme.message('birthDate') class="date-picker" dateTimeFormat="yyyy-MM-dd" required=true/]
          [#else]
            [#if application.registrationConfiguration.loginIdType == 'email']
              [@helpers.input type="text" name="user.email" id="email" label=theme.message('email') autocomplete="username" autocapitalize="none" autocorrect="off" spellcheck="false" autofocus=true placeholder=theme.message('email') required=true/]
            [#else]
              [@helpers.input type="text" name="user.username" id="username" label=theme.message('username') autocomplete="username" autocapitalize="none" autocorrect="off" spellcheck="false" autofocus=true placeholder=theme.message('username') required=true/]
            [/#if]
            [@helpers.input type="password" name="user.password" id="password" label=theme.message('password') autocomplete="new-password" placeholder=theme.message('password') required=true/]
            [#-- Password confirmation removed per CX-7665 --]
            [#-- [#if application.registrationConfiguration.confirmPassword]
              [@helpers.input type="password" name="passwordConfirm" id="passwordConfirm" label=theme.message('passwordConfirm') autocomplete="new-password" placeholder=theme.message('passwordConfirm') required=true/]
            [/#if] --]
            [#if parentEmailRequired]
              [@helpers.input type="text" name="user.parentEmail" id="parentEmail" label=theme.message('parentEmail') placeholder=theme.message('parentEmail') required=true/]
            [/#if]
            [#if application.registrationConfiguration.birthDate.enabled ||
            application.registrationConfiguration.firstName.enabled    ||
            application.registrationConfiguration.fullName.enabled     ||
            application.registrationConfiguration.middleName.enabled   ||
            application.registrationConfiguration.lastName.enabled     ||
            application.registrationConfiguration.mobilePhone.enabled  ||
            application.registrationConfiguration.preferredLanguages.enabled ]
              <div class="mt-5 mb-5"></div>
              [#if application.registrationConfiguration.firstName.enabled]
                [@helpers.input type="text" name="user.firstName" id="firstName" class="col-span-1" label=theme.message('firstName') placeholder=theme.message('firstName') required=application.registrationConfiguration.firstName.required/]
              [/#if]
              [#if application.registrationConfiguration.fullName.enabled]
                [@helpers.input type="text" name="user.fullName" id="fullName" class="lg:col-span-2" label=theme.message('fullName') placeholder=theme.message('fullName') required=application.registrationConfiguration.fullName.required/]
              [/#if]
              [#if application.registrationConfiguration.middleName.enabled]
                [@helpers.input type="text" name="user.middleName" id="middleName" class="col-span-1" label=theme.message('middleName') placeholder=theme.message('middleName') required=application.registrationConfiguration.middleName.required/]
              [/#if]
              [#if application.registrationConfiguration.lastName.enabled]
                [@helpers.input type="text" name="user.lastName" id="lastName" class="col-span-1" label=theme.message('lastName') placeholder=theme.message('lastName') required=application.registrationConfiguration.lastName.required/]
              [/#if]
              [#if application.registrationConfiguration.birthDate.enabled && !hideBirthDate]
                [@helpers.input type="text" name="user.birthDate" id="birthDate" class="lg:col-span-2" label=theme.message('birthDate') class="date-picker" dateTimeFormat="yyyy-MM-dd" placeholder=theme.message('birthDate') required=application.registrationConfiguration.birthDate.required/]
              [/#if]
              [#if application.registrationConfiguration.mobilePhone.enabled]
                [@helpers.input type="text" name="user.mobilePhone" id="mobilePhone" class="lg:col-span-2" label=theme.message('mobilePhone') placeholder=theme.message('mobilePhone') required=application.registrationConfiguration.mobilePhone.required/]
              [/#if]
            [/#if]
          [/#if]

          [#-- Regional marketing consent: Checkbox for UK/EU/CAN/AUS, auto opt-in with info text for others --]
          [#if helpers.requiresOptInCheckbox()]
            [#-- UK, EU, Canada, Australia: Show checkbox (unchecked by default) --]
            [@helpers.input type="checkbox" name="user.data.marketingConsent" id="marketingConsent" class="lg:col-span-2" value="true" uncheckedValue="false" label="Get training tips straight to your inbox" /]
          [#else]
            [#-- US and other countries: Auto opt-in with informational copy --]
            [@helpers.hidden name="user.data.marketingConsent" value="true"/]
            <div class="w-full text-left my-4 lg:col-span-2">
              <span class="font-sans text-sm vdb-info-text">We'll send you account updates and occasional product news. Unsubscribe anytime.</span>
            </div>
          [/#if]

          [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
          [@helpers.hidden name="rememberDevice" value="false"/]
          [#-- Terms consent checkbox replaced with acceptance statement per CX-7665 --]
          <div class="w-full text-left mt-8 lg:col-span-2">
            <span class="font-sans text-sm">By signing up, you agree to Centr's <a href="${(application.data.privacyPolicyUrl)!'https://centr.com/blog/show/5293/privacy-policy'}" class="underline" target="_blank" rel="noopener noreferrer">Privacy Policy</a> and <a href="${(application.data.termsAndConditionsUrl)!'https://centr.com/blog/show/5294/terms-and-conditions'}" class="underline" target="_blank" rel="noopener noreferrer">Terms & Conditions</a>.</span>
          </div>
        </fieldset>
        [/#if]
        [#-- End Basic Self Service Registration Form --]

        [#-- Begin Self Service Custom Registration Form Step Counter --]
        [#if step > 0 && totalSteps > 1]
          <div class="w-full text-center text-sm font-sans text-gray-500 mt-4">
            ${theme.message('register-step', step, totalSteps)}
          </div>
        [/#if]
        [#-- End Self Service Custom Registration Form Step Counter --]

        [@helpers.button id="register-button" icon="arrow-right" text=theme.message('register-btn')/]
      </form>

      [#-- Social login buttons (depends on FusionAuth identity provider configuration) --]
      [#if identityProviders?has_content]
        [@helpers.dividerOr/]

        [@helpers.alternativeLogins
          clientId=client_id
          identityProviders=identityProviders![]
          passwordlessEnabled=false
          bootstrapWebauthnEnabled=false
          idpRedirectState=idpRedirectState
          federatedCSRFToken=federatedCSRFToken
          showOrDivider=false
        /]
      [/#if]
    [/@helpers.authCard]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]