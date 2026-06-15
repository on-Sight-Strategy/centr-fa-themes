[#ftl/]
[#-- @ftlvariable name="allowPhoneNumberChange" type="boolean" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="collectVerificationCode" type="boolean" --]
[#-- @ftlvariable name="phoneNumber" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="verificationId" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Phone verification uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]

      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("phone-verification-required-title")!"VERIFY YOUR"}</h2>
        <h2 class="font-degular-black vdb-title-brand">${theme.message("phone-verification-required-title-line2")!"PHONE NUMBER"}</h2>
      </div>

      [#-- Description --]
      <p class="mt-0 mb-6 font-suisseintl-regular text-white/80">
        ${theme.message("{description}phone-verification-required")}
      </p>

      [#-- If configured, collect the verification code on this form --]
      [#if collectVerificationCode]
        <form id="verification-required-enter-code" action="${request.contextPath}/phone/verification-required" method="POST" class="w-full">
          [@helpers.oauthHiddenFields/]
          [@helpers.hidden name="action" value="verify"/]
          [@helpers.hidden name="collectVerificationCode"/]
          [@helpers.hidden name="phoneNumber"/]
          [@helpers.hidden name="verificationId"/]

          <fieldset class="space-y-6">
            [@helpers.input type="text" name="oneTimeCode" id="otp" autocapitalize="none" autofocus=true autocomplete="one-time-code" autocorrect="off" label=theme.message('verificationCode') placeholder="" required=true/]

            [#-- Spacer for fixed footer --]
            <div class="h-24"></div>
          </fieldset>

          [#-- VDB: Fixed footer button --]
          <div class="vdb-fixed-footer">
            [@helpers.button text=theme.message("submit")/]
          </div>
        </form>

        [#-- Resend link --]
        <form id="verification-required-resend-code" action="${request.contextPath}/phone/verification-required" method="POST" class="w-full mt-4">
          [@helpers.oauthHiddenFields/]
          [@helpers.hidden name="action" value="resend"/]
          [@helpers.hidden name="collectVerificationCode"/]
          [@helpers.hidden name="phoneNumber"/]
          <div class="text-center">
            <button type="submit" class="text-white underline font-suisseintl-regular">
              ${theme.message('phone-verification-required-send-another')}
            </button>
          </div>
        </form>
      [#else]
        <p class="mb-6 font-suisseintl-regular text-white/80">
          ${theme.message("{description}phone-verification-required-non-interactive")}
        </p>
      [/#if]

    [/@helpers.mainBoost]

    [@helpers.footer]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]