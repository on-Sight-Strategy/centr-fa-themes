[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="fields" type="java.util.List<io.fusionauth.domain.form.FormField>" --]
[#-- @ftlvariable name="step" type="int" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="pendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="totalSteps" type="int" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | OAuth Complete Registration"]
    [#-- Custom <head> code goes here --]
    <style>
      .alert.info { display: none; }
    </style>
    <script>
    document.addEventListener('DOMContentLoaded', () => {
      var firstInput = document.querySelector('form[action="/oauth2/complete-registration"]').querySelector('input:not([type=hidden])');
      if (firstInput !== null) {
          firstInput.focus();
      }

      const uvpaAvailableField = document.querySelector('input[name="userVerifyingPlatformAuthenticatorAvailable"]');
      if (uvpaAvailableField !== null && typeof(PublicKeyCredential) !== 'undefined' && PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable) {
        PublicKeyCredential
          .isUserVerifyingPlatformAuthenticatorAvailable()
          .then(result => uvpaAvailableField.value = result);
      }

      // Auto-submit for countries that don't require explicit opt-in
      var autoSubmitForm = document.getElementById('auto-submit-complete-registration');
      if (autoSubmitForm) {
        autoSubmitForm.submit();
      }
    });
    </script>
  [/@helpers.head]
  [@helpers.body]

    [#-- Determine if this user needs explicit opt-in (UK/EU/CAN/AUS) --]
    [#assign showOptInForm = helpers.requiresOptInCheckbox()]

    [#if showOptInForm]
    [#-- Countries requiring explicit opt-in: Show the full form with checkbox --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]
      [#-- VDB: Custom two-line title --]
      <div class="w-full text-left md:text-center mb-6">
        <h2 class="font-degular-black vdb-title-white">ACCOUNT VERIFIED.</h2>
        <h2 class="font-degular-black vdb-title-brand">NOW, STRENGTHEN YOUR INBOX.</h2>
      </div>

      [#-- Email inbox preview image --]
      <div class="relative w-full flex justify-center">
        <img src="https://images.ctfassets.net/c9t7ta4z3not/4yssWZsmMk261uIXM8glAA/d595e65189fe61cb95ee2335ca1848a4/Email.png"
             alt="Email inbox preview"
             class="w-full max-w-[297px] rounded-[24px]" />
        [#-- Gradient overlay fading to black --]
        <div class="absolute bottom-0 left-0 right-0 h-[200px] bg-gradient-to-b from-transparent to-black rounded-b-[24px]"></div>
      </div>

      [#-- Bottom panel with form --]
      <form id="optin-form" action="${request.contextPath}/oauth2/complete-registration" method="POST" class="vdb-optin-panel">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="step"/]
        [@helpers.hidden name="registrationState"/]
        [@helpers.hidden name="userVerifyingPlatformAuthenticatorAvailable"/]

        [#-- Begin Self Service Custom Registration Form Steps --]
        [#if fields?has_content]
          <fieldset class="space-y-6">
            [#list fields as field]
              [#if (field.key!"")?contains("marketingOptIn")]
                <p class="vdb-optin-text">
                  Sign up to receive program recommendations, guides, and more to augment your fitness journey.
                </p>
                [@helpers.input type="checkbox" name=field.key id=field.key label="Get training tips straight to your inbox." required=false value="true" uncheckedValue="false" /]
              [#elseif (field.key!"")?contains("marketingConsent")]
                [@helpers.input type="checkbox" name=field.key id=field.key label=field.name required=false value="true" uncheckedValue="false" /]
              [#elseif field.control == 'textarea']
                [@helpers.textarea name=field.key id=field.key label=field.name required=field.required/]
              [#elseif field.type == 'bool']
                [@helpers.input type="checkbox" name=field.key id=field.key label=field.name required=field.required value="true" uncheckedValue="false" /]
              [#elseif field.type == 'select' || field.control == 'select']
                [@helpers.select name=field.key id=field.key label=field.name required=field.required options=field.options![]/]
              [#elseif field.type == 'number']
                [@helpers.input type="number" name=field.key id=field.key label=field.name required=field.required/]
              [#elseif field.key?contains('password')]
                [@helpers.input type="password" name=field.key id=field.key label=field.name required=field.required placeholder=field.name autofocus=field?is_first autocomplete="new-password"/]
              [#else]
                [@helpers.input type="text" name=field.key id=field.key label=field.name required=field.required placeholder=field.name autofocus=field?is_first/]
              [/#if]

              [#if field.confirm]
                [@helpers.input type=(field.key?contains('password'))?then("password", "text") name="confirm.${field.key}" id="confirm.${field.key}" label="Confirm ${field.name}" required=true/]
              [/#if]
            [/#list]
          </fieldset>
        [#else]
        <fieldset class="space-y-6">
          [#if application.registrationConfiguration.firstName.enabled]
            [@helpers.input type="text" name="user.firstName" id="firstName" label=theme.message("firstName") placeholder=theme.message("firstName") required=application.registrationConfiguration.firstName.required/]
          [/#if]
          [#if application.registrationConfiguration.fullName.enabled]
            [@helpers.input type="text" name="user.fullName" id="fullName" label=theme.message("fullName") placeholder=theme.message("fullName") required=application.registrationConfiguration.fullName.required/]
          [/#if]
          [#if application.registrationConfiguration.middleName.enabled]
            [@helpers.input type="text" name="user.middleName" id="middleName" label=theme.message("middleName") placeholder=theme.message("middleName") required=application.registrationConfiguration.middleName.required/]
          [/#if]
          [#if application.registrationConfiguration.lastName.enabled]
            [@helpers.input type="text" name="user.lastName" id="lastName" label=theme.message("lastName") placeholder=theme.message("lastName") required=application.registrationConfiguration.lastName.required/]
          [/#if]
          [#if application.registrationConfiguration.birthDate.enabled]
            [@helpers.input type="text" name="user.birthDate" id="birthDate" label=theme.message("birthDate") class="date-picker" dateTimeFormat="yyyy-MM-dd" placeholder=theme.message("birthDate") required=application.registrationConfiguration.birthDate.required/]
          [/#if]
          [#if application.registrationConfiguration.mobilePhone.enabled]
            [@helpers.input type="text" name="user.mobilePhone" id="mobilePhone" label=theme.message("mobilePhone") placeholder=theme.message("mobilePhone") required=application.registrationConfiguration.mobilePhone.required/]
          [/#if]
          [#if application.registrationConfiguration.preferredLanguages.enabled]
            [@helpers.locale_select field="" name="user.preferredLanguages" id="preferredLanguages" label=theme.message("preferredLanguage") required=application.registrationConfiguration.preferredLanguages.required /]
          [/#if]
        </fieldset>
        [/#if]

      </form>

      [#-- Spacer for fixed footer --]
      <div class="h-24"></div>

      [#-- VDB: Fixed footer button --]
      <div class="vdb-fixed-footer">
        <button type="submit" form="optin-form" class="btn btn-primary">
          <span class="btn-text">[#if step == totalSteps || !fields?has_content]CONTINUE[#else]Next[/#if]</span>
          <span class="btn-spinner">
            <svg class="animate-spin" width="20" height="20" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle style="opacity: 0.25" cx="12" cy="12" r="10" stroke="#2f2c2c" stroke-width="4"></circle>
              <path style="opacity: 0.75" fill="#2f2c2c" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </span>
        </button>
      </div>
    [/@helpers.mainBoost]
    [#else]
    [#-- Countries NOT requiring explicit opt-in: Auto-submit with spinner --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]
      <div class="flex flex-col items-center justify-center flex-grow min-h-[60vh]">
        <svg class="animate-spin" width="48" height="48" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle style="opacity: 0.25" cx="12" cy="12" r="10" stroke="#ffffff" stroke-width="2"></circle>
          <circle style="opacity: 0.75" cx="12" cy="12" r="10" stroke="#ffffff" stroke-width="2" stroke-dasharray="16 48" stroke-linecap="round"></circle>
        </svg>
      </div>

      <form id="auto-submit-complete-registration" action="${request.contextPath}/oauth2/complete-registration" method="POST" class="full" style="display: none;">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="step"/]
        [@helpers.hidden name="registrationState"/]
        [@helpers.hidden name="userVerifyingPlatformAuthenticatorAvailable"/]

        [#if fields?has_content]
          [#list fields as field]
            [#if (field.key!"")?contains("marketingOptIn") || (field.key!"")?contains("marketingConsent")]
              [@helpers.hidden name=field.key value="true"/]
            [#else]
              [@helpers.hidden name=field.key/]
            [/#if]
          [/#list]
        [/#if]
      </form>
    [/@helpers.mainBoost]
    [/#if]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]